// ignore_for_file: file_names, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import '../CustomItem/BackgroundContainer.dart';
import '../CustomItem/CustomButton.dart';
import '../CustomItem/CustomFormField.dart';
import '../Providers/UsersProvider.dart';
import 'package:provider/provider.dart';

class ModificaProfiloWidget extends StatefulWidget {
  final String currentUserId;
  final String userRole;

  const ModificaProfiloWidget(
      {required this.currentUserId, required this.userRole, super.key});

  @override
  State<ModificaProfiloWidget> createState() => _ModificaProfiloWidgetState();
}

class _ModificaProfiloWidgetState extends State<ModificaProfiloWidget> {
  late TextEditingController fullNameController;
  late TextEditingController emailAddressController;
  late UsersProvider userProvider;

  @override
  void initState() {
    super.initState();
    userProvider = Provider.of<UsersProvider>(context, listen: false);
    fullNameController = TextEditingController();
    emailAddressController = TextEditingController();
  }

  @override
  void dispose() {
    fullNameController.dispose();
    emailAddressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (FocusScope.of(context).hasFocus) {
          FocusScope.of(context).unfocus();
        }
      },
      child: PopScope(
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: _buildAppBar(),
            body: _buildBody()),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text(
        'Modifica il tuo profilo',
        style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white),
      ),
      centerTitle: true,
      automaticallyImplyLeading: true,
      backgroundColor: Colors.black,
    );
  }

  Widget _buildBody() {
    return Stack(
      children: [
        const BackgroundContainer(),
        SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                  child: CustomTextInput(
                    controller: fullNameController,
                    labelText: 'Modifica il tuo user-name',
                  ),
                ),
                const SizedBox(height: 24),
                CustomButton(
                  text: 'Modifica Informazioni',
                  onPressed: () {
                    userProvider.updateUsernameWithUpdate(
                        fullNameController.text, context);
                    Navigator.pop(context);
                  },
                  backgroundColor: Colors.white,
                  colortext: Colors.black,
                ),
                const SizedBox(height: 24),
                CustomButton(
                  text: 'Cancella il tuo Account',
                  onPressed: () {
                    userProvider.deleteUserAccountMongoDB(context);
                  },
                  backgroundColor: Colors.red,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
