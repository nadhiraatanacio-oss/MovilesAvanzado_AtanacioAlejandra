import SwiftUI

// Paleta de la app
extension Color {
    static let fondoApp = Color(red: 0.97, green: 0.96, blue: 0.94)
    static let tinta = Color(red: 0.11, green: 0.13, blue: 0.25)
    static let coral = Color(red: 1.0, green: 0.42, blue: 0.35)
    static let menta = Color(red: 0.30, green: 0.78, blue: 0.66)
    static let oro = Color(red: 1.0, green: 0.74, blue: 0.10)
    static let grisSuave = Color(red: 0.55, green: 0.56, blue: 0.62)
}

// Color del avatar según el id del usuario
func colorAvatar(_ id: Int) -> Color {
    let colores: [Color] = [.coral, .menta, .oro, .tinta, .grisSuave]
    return colores[abs(id) % colores.count]
}

// Iniciales del nombre (ej. "Leanne Graham" -> "LG")
func inicialesDe(_ nombre: String) -> String {
    nombre.split(separator: " ").prefix(2).compactMap { $0.first }.map(String.init).joined().uppercased()
}

struct ContentView: View {
    @StateObject private var viewModel = UserViewModel()

    @State private var showingForm = false
    @State private var editingUser: User? = nil
    @State private var usuarioSeleccionado: User? = nil   // Para abrir el detalle

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                Color.fondoApp.ignoresSafeArea()

                VStack(spacing: 0) {
                    encabezado

                    List {
                        ForEach(viewModel.filteredUsers) { user in
                            FilaUsuario(user: user,
                                        esFavorito: viewModel.favoritos.contains(user.id)) {
                                viewModel.toggleFavorito(user)
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                usuarioSeleccionado = user   // Abre el detalle
                            }
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                            .listRowInsets(EdgeInsets(top: 6, leading: 20, bottom: 6, trailing: 20))
                            .swipeActions {
                                Button(role: .destructive) {
                                    Task { await viewModel.deleteUser(id: user.id) }
                                } label: {
                                    Label("Eliminar", systemImage: "trash")
                                }

                                Button {
                                    editingUser = user
                                    showingForm = true
                                } label: {
                                    Label("Editar", systemImage: "pencil")
                                }
                                .tint(.tinta)
                            }
                        }

                        if viewModel.filteredUsers.isEmpty && !viewModel.cargando {
                            Text(viewModel.soloFavoritos ? "Aún no marcas favoritos ⭐" : "No se encontraron usuarios")
                                .font(.system(size: 15, weight: .medium, design: .rounded))
                                .foregroundColor(.grisSuave)
                                .frame(maxWidth: .infinity)
                                .padding(.top, 40)
                                .listRowBackground(Color.clear)
                                .listRowSeparator(.hidden)
                        }
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                    // Extra 2: deslizar hacia abajo para recargar
                    .refreshable {
                        await viewModel.fetchUsers()
                    }
                }

                // Botón flotante para agregar
                Button {
                    editingUser = nil
                    showingForm = true
                } label: {
                    Image(systemName: "plus")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 62, height: 62)
                        .background(Color.coral)
                        .clipShape(Circle())
                        .shadow(color: .coral.opacity(0.4), radius: 10, y: 5)
                }
                .padding(24)
            }
            .toolbar(.hidden, for: .navigationBar)
            .navigationDestination(item: $usuarioSeleccionado) { user in
                UserDetailView(user: user)
            }
            .onAppear {
                if viewModel.users.isEmpty {
                    Task { await viewModel.fetchUsers() }
                }
            }
            .sheet(isPresented: $showingForm) {
                if let user = editingUser {
                    UserFormView(name: user.name, email: user.email, isEditing: true) { name, email in
                        // Conserva los demás datos del usuario y solo cambia nombre y email
                        var updated = user
                        updated.name = name
                        updated.email = email
                        Task { await viewModel.updateUser(user: updated) }
                    }
                } else {
                    UserFormView(name: "", email: "", isEditing: false) { name, email in
                        Task { await viewModel.createUser(name: name, email: email) }
                    }
                }
            }
        }
        .tint(.coral)
        .preferredColorScheme(.light)
    }

    // Encabezado con contador, buscador y filtro de favoritos
    private var encabezado: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("SEMANA 13 · API REST")
                        .font(.system(size: 11, weight: .bold, design: .rounded))
                        .tracking(1.5)
                        .foregroundColor(.coral)
                    Text("Directorio")
                        .font(.system(size: 34, weight: .heavy, design: .rounded))
                        .foregroundColor(.white)
                }
                Spacer()
                if viewModel.cargando {
                    ProgressView().tint(.white)
                }
            }

            HStack(spacing: 14) {
                Chip(valor: "\(viewModel.users.count)", texto: "usuarios", color: .menta)
                Chip(valor: "\(viewModel.favoritos.count)", texto: "favoritos", color: .oro)
            }

            HStack(spacing: 10) {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.grisSuave)
                    TextField("Buscar usuario por nombre", text: $viewModel.searchText)
                        .foregroundColor(.tinta)
                        .autocorrectionDisabled()
                }
                .padding(12)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 14))

                // Extra 1: filtrar solo favoritos
                Button {
                    viewModel.soloFavoritos.toggle()
                } label: {
                    Image(systemName: viewModel.soloFavoritos ? "star.fill" : "star")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(viewModel.soloFavoritos ? .tinta : .white)
                        .frame(width: 46, height: 46)
                        .background(viewModel.soloFavoritos ? Color.oro : Color.white.opacity(0.15))
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }
            }
        }
        .padding(20)
        .padding(.top, 10)
        .background(
            UnevenRoundedRectangle(bottomLeadingRadius: 28, bottomTrailingRadius: 28)
                .fill(Color.tinta)
                .ignoresSafeArea(edges: .top)
        )
    }
}

struct Chip: View {
    let valor: String
    let texto: String
    let color: Color

    var body: some View {
        HStack(spacing: 6) {
            Text(valor)
                .font(.system(size: 15, weight: .heavy, design: .rounded))
                .foregroundColor(.tinta)
                .padding(.horizontal, 9)
                .padding(.vertical, 2)
                .background(color)
                .clipShape(Capsule())
            Text(texto)
                .font(.system(size: 13, weight: .semibold, design: .rounded))
                .foregroundColor(.white.opacity(0.85))
        }
    }
}

struct FilaUsuario: View {
    let user: User
    let esFavorito: Bool
    var onFavorito: () -> Void

    var body: some View {
        HStack(spacing: 14) {
            Text(inicialesDe(user.name))
                .font(.system(size: 16, weight: .heavy, design: .rounded))
                .foregroundColor(.white)
                .frame(width: 48, height: 48)
                .background(colorAvatar(user.id))
                .clipShape(RoundedRectangle(cornerRadius: 16))

            VStack(alignment: .leading, spacing: 3) {
                Text(user.name)
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(.tinta)
                    .lineLimit(1)
                Text(user.email)
                    .font(.system(size: 13, weight: .medium, design: .rounded))
                    .foregroundColor(.grisSuave)
                    .lineLimit(1)
            }

            Spacer()

            Button(action: onFavorito) {
                Image(systemName: esFavorito ? "star.fill" : "star")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(esFavorito ? .oro : .grisSuave.opacity(0.6))
            }
            .buttonStyle(.plain)

            Image(systemName: "chevron.right")
                .font(.system(size: 13, weight: .bold))
                .foregroundColor(.grisSuave.opacity(0.5))
        }
        .padding(14)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.04), radius: 8, y: 3)
    }
}

#Preview {
    ContentView()
}
