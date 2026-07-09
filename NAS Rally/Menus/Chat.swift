import SwiftUI
import Supabase

struct ChatView: View {
    @Binding var person: PersonInfo
    @State private var availableRallies: [RallyRow] = []
    
    struct RallyRow: Codable, Identifiable {
        let id: UUID
        let name: String
    }
    
    var body: some View {
        NavigationStack {
            List(availableRallies) { rally in
                // Pass the groupName and a pre-initialized ViewModel
                NavigationLink(destination: MessageThreadView(
                    person: $person,
                    viewModel: ChatViewModel(client: supabase, groupId: rally.id),
                    groupName: rally.name
                )) {
                    HStack {
                        Image("RallyLogos/Logo" + rally.name)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                        Text(rally.name)
                    }
                }
            }
            .navigationTitle("Chat")
            .task {
                await fetchJoinedRallies()
            }
        }
    }
    
    private func fetchJoinedRallies() async {
        guard !person.rallieNames.isEmpty else { return }
        do {
            let rows: [RallyRow] = try await supabase.from("rallies")
                .select("id, name")
                .in("name", values: person.rallieNames)
                .execute()
                .value
            self.availableRallies = rows
        } catch {
            print("Error loading joined rallies: \(error)")
        }
    }
}

struct MessageThreadView: View {
    @Environment(\.dismiss) private var dismiss // Required to handle custom back button
    @Binding var person: PersonInfo
    @StateObject var viewModel: ChatViewModel
    @State private var messageInput: String = ""
    let groupName: String
    
    init(person: Binding<PersonInfo>, viewModel: ChatViewModel, groupName: String) {
        self._person = person
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.groupName = groupName
    }
    
    var body: some View {
        ZStack(alignment: .top) { // Align top so header anchors correctly
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(viewModel.messages.reversed()) { message in
                        MessageBubble(message: message, isCurrentUser: message.senderId == person.id)
                    }
                }
                // Push content below your tall floating header
                .padding(.top, 130)
                .padding(.bottom, 150)
                .refreshable {
                    await viewModel.loadMessages(isRefresh: false)
                }
            }
            .scrollDismissesKeyboard(.interactively)
            .defaultScrollAnchor(.bottom)
            .ignoresSafeArea()
            
            // --- CUSTOM FULL-BLEED GLASS HEADER ---
            VStack(spacing: 4) {
                // Creates top clearance for the status bar
                Spacer()
                    .frame(height: 50)
                
                // Using a ZStack ensures the title stays perfectly centered
                // without getting pushed around by the back button's width.
                ZStack {
                    // 1. Left-aligned Back Button Pill
                    HStack {
                        Button(action: { dismiss() }) {
                            HStack(spacing: 6) {
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 16, weight: .bold))
                            }
                            .foregroundStyle(.primary) // Removes the default blue tint
                            .frame(width: 38, height: 38) // Circular dimensions
                            .background {
                                // Micro-glass pill background matching your input style
                                Color.clear.glassEffectCompat(in: Circle())
                            }
                            .overlay(Circle().stroke(Color.white.opacity(0.2), lineWidth: 0.5))
                        }
                        .padding(.leading, 16)
                        
                        Spacer()
                    }
                    
                    // 2. Perfectly Centered Group Content
                    VStack(spacing: 2) {
                        Image("RallyLogos/Logo" + groupName)
                            .resizable()
                            .frame(width: 55, height: 44)
                            .clipShape(Circle())
                        Text(groupName)
                            .font(.headline)
                            .foregroundStyle(.primary)
                    }
                }
                .padding(.bottom, 12)
            }
            .background {
                // Overall full-bleed header background blur
                Color.clear.glassEffectCompat(.regular, in: Rectangle())
            }
            .overlay(
                VStack {
                    Spacer()
                    Color.white.opacity(0.15).frame(height: 0.5)
                }
            )
            .ignoresSafeArea(edges: .top)
            
            // --- INPUT PILL ---
            VStack {
                Spacer()
                HStack {
                    TextField("Message", text: $messageInput)
                        .font(.subheadline).padding(12)
                    
                    Button(action: {
                        guard !messageInput.trimmingCharacters(in: .whitespaces).isEmpty else { return }
                        
                        let contentToSend = messageInput
                        messageInput = ""
                        
                        Task {
                            await viewModel.sendMessage(contentToSend, senderId: person.id)
                        }
                    }) {
                        Image(systemName: "arrow.up.circle.fill")
                            .font(.title2)
                            .foregroundStyle(messageInput.isEmpty ? .gray : .blue)
                    }
                    .disabled(messageInput.isEmpty)
                    .padding(.trailing, 8)
                }
                .background {
                    Color.clear.glassEffectCompat(in: Capsule())
                }
                .overlay(Capsule().stroke(Color.white.opacity(0.2), lineWidth: 0.5))
                .padding(.horizontal, 16)
                .padding(.bottom, 20)
            }
        }
        .task { await viewModel.loadMessages(isRefresh: true) }
        // Completely hides native bar so it doesn't duplicate titles or backgrounds
        .toolbar(.hidden, for: .navigationBar)
    }
}



struct MessageBubble: View {
    let message: Message
    let isCurrentUser: Bool
    
    var body: some View {
        HStack {
            if isCurrentUser { Spacer() }
            
            VStack(alignment: isCurrentUser ? .trailing : .leading) {
                Text(message.content)
                    .padding(12)
                    .background(isCurrentUser ? Color.blue : Color.gray.opacity(0.2))
                    .foregroundColor(isCurrentUser ? .white : .primary)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                
                Text(message.createdAt.formatted(date: .omitted, time: .shortened))
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 4)
            }
            
            if !isCurrentUser { Spacer() }
        }
        .padding(.horizontal)
    }
}
