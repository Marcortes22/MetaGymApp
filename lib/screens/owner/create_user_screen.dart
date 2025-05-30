import 'package:flutter/material.dart';
import '../../../services/user_service.dart';

class CreateUserScreen extends StatefulWidget {
  const CreateUserScreen({super.key});

  @override
  State<CreateUserScreen> createState() => _CreateUserScreenState();
}

class _CreateUserScreenState extends State<CreateUserScreen> {
  final _formKey = GlobalKey<FormState>();
  final _userService = UserService();
  
  String _name = '';
  String _email = '';
  String _password = '';
  String _selectedRole = 'cli';
  bool _isLoading = false;

  final _roles = [
    {'value': 'cli', 'label': 'Cliente', 'icon': Icons.person_outline},
    {'value': 'coa', 'label': 'Entrenador', 'icon': Icons.fitness_center},
    {'value': 'sec', 'label': 'Secretaria', 'icon': Icons.support_agent},
    {'value': 'own', 'label': 'Administrador', 'icon': Icons.admin_panel_settings_outlined},
  ];

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

  void _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() => _isLoading = true);

      try {
        await _userService.createUser(
          email: _email,
          password: _password,
          name: _name,
          role: _selectedRole,
        );
        if (mounted) {
          Navigator.pop(context, true);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
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
          icon: const Icon(Icons.close, color: Color(0xFFFF8C42)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Crear Usuario',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                color: Colors.white.withOpacity(0.05),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Nombre completo',
                          labelStyle: TextStyle(color: Colors.grey[400]),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey[700]!),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFFF8C42)),
                          ),
                        ),
                        style: const TextStyle(color: Colors.white),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingrese el nombre';
                          }
                          return null;
                        },
                        onSaved: (value) => _name = value ?? '',
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Correo electrónico',
                          labelStyle: TextStyle(color: Colors.grey[400]),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey[700]!),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFFF8C42)),
                          ),
                        ),
                        style: const TextStyle(color: Colors.white),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingrese el correo';
                          }
                          if (!value.contains('@')) {
                            return 'Por favor ingrese un correo válido';
                          }
                          return null;
                        },
                        onSaved: (value) => _email = value ?? '',
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Contraseña',
                          labelStyle: TextStyle(color: Colors.grey[400]),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey[700]!),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFFF8C42)),
                          ),
                        ),
                        style: const TextStyle(color: Colors.white),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingrese la contraseña';
                          }
                          if (value.length < 6) {
                            return 'La contraseña debe tener al menos 6 caracteres';
                          }
                          return null;
                        },
                        onSaved: (value) => _password = value ?? '',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                color: Colors.white.withOpacity(0.05),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: _roles.map((role) {
                    final bool isSelected = _selectedRole == role['value'];
                    return InkWell(
                      onTap: () {
                        setState(() {
                          _selectedRole = role['value'] as String;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.grey[800]!,
                              width: 1,
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: _getRoleColor(role['value'] as String)
                                  .withOpacity(isSelected ? 1 : 0.2),
                              child: Icon(
                                role['icon'] as IconData,
                                color: isSelected ? Colors.white : _getRoleColor(role['value'] as String),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Text(
                              role['label'] as String,
                              style: TextStyle(
                                color: isSelected ? Colors.white : Colors.grey[400],
                                fontSize: 16,
                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                              ),
                            ),
                            const Spacer(),
                            if (isSelected)
                              Icon(
                                Icons.check_circle,
                                color: _getRoleColor(role['value'] as String),
                              ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _handleSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF8C42),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text(
                        'Crear Usuario',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
