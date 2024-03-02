
import SwiftUI

struct StoryPostView: View {
    // MARK: - Properties
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: StoryPostViewModel
    @State private var selectedQuote: Quote?
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            VStack(spacing: 8) {
                headerTextField
                
                bodyTextField
                
                Spacer()
                
                spoilersToggle
                
                addPostButton
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
            .background(Color(uiColor: .customBackgroundColor))
            .navigationBarItems(trailing: addQuoteButton)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .sheet(isPresented: $viewModel.isAddPostSheetPresented) {
            AddQuoteView(viewModel: AddQuoteViewModel(), selectedQuote: $selectedQuote)
        }
    }
    
    // MARK: - Views
    private var headerTextField: some View {
        TextField("", text: $viewModel.headerText, prompt: Text("Post Header...").foregroundColor(.black), axis: .vertical)
            .autocorrectionDisabled()
            .textFieldStyle(.plain)
            .lineLimit(1)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(uiColor: .customAccentColor.withAlphaComponent(0.5)))
            )
            .foregroundColor(.black)
            .padding(EdgeInsets(top: 20, leading: 0, bottom: 20, trailing: 0))
    }
    
    private var bodyTextField: some View {
        TextField("", text: $viewModel.bodyText, prompt: Text("Post Body...").foregroundColor(.black), axis: .vertical)
            .autocorrectionDisabled()
            .frame(height: 200, alignment: .topLeading)
            .textFieldStyle(.plain)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(uiColor: .customAccentColor.withAlphaComponent(0.5)))
            )
            .foregroundColor(.black)
            .onChange(of: selectedQuote) { newQuote in
                if let quote = newQuote {
                    viewModel.bodyText += "\(quote.text) - \(quote.author)."
                    viewModel.addQuote(quote)
                    selectedQuote = nil
                }
            }
    }
    
    private var spoilersToggle: some View {
        Toggle("Allow Spoilers", isOn: $viewModel.isSpoilersAllowed)
            .padding()
            .foregroundColor(.white)
            .tint(Color(uiColor: .customAccentColor))
    }
    
    private var addQuoteButton: some View {
        Button(action: {
            viewModel.isAddPostSheetPresented.toggle()
        }) {
            Text("Add Quote")
        }
    }
    
    private var addPostButton: some View {
        Button {
            viewModel.addPost()
            dismiss()
        } label: {
            RoundedRectangle(cornerRadius: 8)
                .frame(height: 50)
                .overlay(content: {
                    Text("Add Post")
                        .foregroundStyle(.black)
                })
        }
    }
}
