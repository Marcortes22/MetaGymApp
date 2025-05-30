import 'package:flutter/material.dart';
import '../../../services/role_service.dart';
import 'create_user_screen.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  final _roleService = RoleService();
  Map<String, bool> _expandedSections = {
    'own': true,
    'coa': true,
    'sec': true,
    'cli': true,
  };

  IconData _getRoleIcon(String role) {
    switch (role) {
      case 'cli':
        return Icons.person_outline;
      case 'coa':
        return Icons.fitness_center;
      case 'own':
        return Icons.admin_panel_settings_outlined;
      case 'sec':
        return Icons.support_agent;
      default:
        return Icons.person_outline;
    }
  }

  Color _getRoleColor(String role) {
    switch (role) {
      case 'own':
        return Colors.purple;
      case 'coa':
        return Colors.green;
      case 'sec':
        return Colors.blue;
      case 'cli':
        return const Color(0xFFFF8C42);
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFFF8C42)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Usuarios',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _roleService.getUsersByRole(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFFFF8C42)),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.white),
              ),
            );
          }

          final roleGroups = snapshot.data ?? [];

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: roleGroups.length,
            itemBuilder: (context, index) {
              final roleGroup = roleGroups[index];
              final role = roleGroup['role'] as String;
              final roleName = roleGroup['name'] as String;
              final users = roleGroup['users'] as List<dynamic>;

              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                color: Colors.white.withOpacity(0.05),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    ListTile(
                      onTap: () {
                        setState(() {
                          _expandedSections[role] = !_expandedSections[role]!;
                        });
                      },
                      contentPadding: const EdgeInsets.all(16),
                      leading: CircleAvatar(
                        backgroundColor: _getRoleColor(role),
                        child: Icon(_getRoleIcon(role), color: Colors.white),
                      ),
                      title: Row(
                        children: [
                          Text(
                            roleName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: _getRoleColor(role).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${users.length}',
                              style: TextStyle(
                                color: _getRoleColor(role),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      trailing: Icon(
                        _expandedSections[role]!
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: _getRoleColor(role),
                      ),
                    ),
                    if (_expandedSections[role]! && users.isNotEmpty)
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: users.length,
                        itemBuilder: (context, userIndex) {
                          final user = users[userIndex];
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                            child: Card(
                              color: Colors.white.withOpacity(0.05),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(12),
                                leading: CircleAvatar(
                                  backgroundColor: Colors.white10,
                                  child: Text(
                                    (user['name'] as String)
                                        .substring(0, 1)
                                        .toUpperCase(),
                                    style: TextStyle(
                                      color: _getRoleColor(role),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  user['name'] ?? 'Sin nombre',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                subtitle: Text(
                                  user['email'] ?? 'Sin correo',
                                  style: TextStyle(
                                    color: Colors.grey[400],
                                    fontSize: 14,
                                  ),
                                ),
                                trailing: PopupMenuButton(
                                  icon: Icon(
                                    Icons.more_vert,
                                    color: _getRoleColor(role),
                                  ),
                                  color: const Color(0xFF2A2A2A),
                                  itemBuilder: (context) => [
                                    PopupMenuItem(
                                      child: ListTile(
                                        leading: const Icon(
                                          Icons.edit,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                        title: const Text(
                                          'Editar',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                          ),
                                        ),
                                        contentPadding: EdgeInsets.zero,
                                        horizontalTitleGap: 8,
                                        onTap: () {
                                          // TODO: Implement edit user
                                        },
                                      ),
                                    ),
                                    PopupMenuItem(
                                      child: ListTile(
                                        leading: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                          size: 20,
                                        ),
                                        title: const Text(
                                          'Eliminar',
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontSize: 14,
                                          ),
                                        ),
                                        contentPadding: EdgeInsets.zero,
                                        horizontalTitleGap: 8,
                                        onTap: () {
                                          // TODO: Implement delete user
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    if (_expandedSections[role]! && users.isEmpty)
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'No hay usuarios con este rol',
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 14,
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          );
        },
      ),      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFFF8C42),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateUserScreen(),
            ),
          );
          if (result == true) {
            setState(() {}); // Refresh the list
          }
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
