import SwiftUI
import SwiftData
import ApollonShared

struct DiagramListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var diagrams: [ApollonDiagram]
    @State private var isImporting = false
    @State private var shouldNavigate = false
    @State private var importErrorMessage: String = ""

    var body: some View {
        NavigationStack {
            VStack {
                if importErrorMessage != "" {
                    ImportErrorMessageView(errorMessage: $importErrorMessage)
                }
                if diagrams.isEmpty {
                    Spacer()

                    Text("No diagrams available...")
                        .foregroundColor(.primary)
                        .font(.title2)
                        .bold()
                        .padding(.horizontal, 20)
                        .padding(.bottom, 10)

                    Text("Add a new diagram with \(Image(systemName: "plus")) or import a diagram with \(Image(systemName: "square.and.arrow.down")).")
                        .foregroundColor(ApollonColor.toolBarItemColor)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)

                    Spacer()
                } else {
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                            ForEach(diagrams) { diagram in
                                DiagramListCellView(diagram: diagram)
                            }
                        }
                        .padding(10)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Image("tum_logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40)
                }
                ToolbarItem(placement: .principal) {
                    Text("Apollon")
                        .font(.title)
                        .bold()
                        .foregroundColor(.white)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        isImporting.toggle()
                    } label: {
                        Image(systemName: "square.and.arrow.down")
                    }
                    .foregroundColor(ApollonColor.toolBarItemColor)
                    .fileImporter(isPresented: $isImporting, allowedContentTypes: [.json], allowsMultipleSelection: false) { result in
                        do {
                            guard let selectedFile: URL = try result.get().first else { return }
                            let file = read(from: selectedFile)
                            switch file {
                            case .success(let stringValue):
                                let importedDiagram = try JSONDecoder().decode(Diagram.self, from: Data(stringValue.utf8))
                                if let type = importedDiagram.model?.type, !UMLDiagramType.isDiagramTypeUnsupported(diagramType: type) {
                                    let diagram = ApollonDiagram(id: importedDiagram.id, title: importedDiagram.title, lastUpdate: importedDiagram.lastUpdate, diagramType: type, model: importedDiagram.model)
                                    if (diagrams.first(where: { $0.id == diagram.id}) == nil) {
                                        withAnimation {
                                            modelContext.insert(diagram)
                                        }
                                    } else {
                                        importErrorMessage = "A diagram with the same ID already exists."
                                        print(importErrorMessage)
                                    }
                                } else {
                                    importErrorMessage = "This diagram type is not supported."
                                    print(importErrorMessage)
                                }
                            case .failure(let error):
                                importErrorMessage = "Error whilst reading file: \(error)"
                                print(importErrorMessage)
                            }
                        } catch {
                            importErrorMessage = "Error whilst importing: \(error.localizedDescription)"
                            print(importErrorMessage)
                        }
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        ForEach(UMLDiagramType.allCases, id: \.self) { type in
                            if !UMLDiagramType.isDiagramTypeUnsupported(diagramType: type) {
                                Button(type.rawValue.insertSpaceBeforeCapitalLetters()) {
                                    withAnimation {
                                        modelContext.insert(ApollonDiagram(diagramType: type))
                                    }
                                }
                            }
                        }
                    } label: {
                        Image(systemName: "plus")
                    }
                    .foregroundColor(ApollonColor.toolBarItemColor)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(ApollonColor.toolBarBackground, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
    }

    // Needed for importing
    private func read(from url: URL) -> Result<String,Error> {
        let accessing = url.startAccessingSecurityScopedResource()
        defer {
            if accessing {
                url.stopAccessingSecurityScopedResource()
            }
        }
        return Result { try String(contentsOf: url) }
    }
}

struct ImportErrorMessageView: View {
    @Binding var errorMessage: String

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Import failed")
                    .foregroundColor(.red)
                    .bold()
                Spacer()
                Button {
                    errorMessage = ""
                } label: {
                    Image(systemName: "x.circle")
                        .foregroundColor(.red)
                }
            }
            Text(errorMessage)
                .foregroundColor(.red)
        }
        .padding(5)
        .overlay {
            RoundedRectangle(cornerRadius: 3)
                .stroke(.red, lineWidth: 1)
        }
        .background {
            RoundedRectangle(cornerRadius: 3)
                .foregroundColor(Color.red.opacity(0.1))
        }
        .padding(.top, 10)
        .padding(.horizontal, 10)
    }
}
