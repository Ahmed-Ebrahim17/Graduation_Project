import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../Common/widgets/show_snackbar.dart';
import '../../../../data/services/api.dart';
import '../../../../utils/constants/text_strings.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../signup/widgets/my_drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ApiServices apiServices = ApiServices();
  final textEditingController = TextEditingController();
  String? token;
  String? summaryId;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  Future<void> _loadToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('auth_token');
    });
    if (token == null) {
      showSnackBar(context, "Authentication token is missing!", Colors.red);
    }
  }

  Future<bool> requestStoragePermission() async {
    if (await Permission.storage.request().isGranted) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> _handleUpload() async {
    if (!await requestStoragePermission()) {
      showSnackBar(context, "Storage permission is required", Colors.red);
      return;
    }
    try {
      setState(() {
        isLoading = true;
        textEditingController.text = "Uploading file...";
      });

      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'txt'],
      );

      if (result != null && result.files.single.path != null) {
        String filePath = result.files.single.path!;

        final response = await apiServices.createSummary(
          context: context,
          filePath: filePath,
        );

        if (response != null) {
          setState(() {
            summaryId = response.id;
            textEditingController.text =
                "File uploaded successfully! Click Summarize to view the summary.";
          });
        } else {
          setState(() {
            textEditingController.text =
                "Failed to upload file. Please try again.";
          });
        }
      } else {
        setState(() {
          textEditingController.text = "No file selected";
        });
        showSnackBar(context, 'No file selected', Colors.red);
      }
    } catch (error) {
      setState(() {
        textEditingController.text = "Error: $error";
      });
      showSnackBar(context, "Failed to upload file. Error: $error", Colors.red);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _handleSummarize() async {
    if (summaryId == null) {
      showSnackBar(context, "Please upload a file first", Colors.red);
      return;
    }

    try {
      setState(() {
        isLoading = true;
        textEditingController.text = "Fetching summary...";
      });

      final summaryText = await apiServices.getSummaryById(
        context: context,
        summaryId: summaryId!,
      );

      setState(() {
        if (summaryText != null && summaryText.isNotEmpty) {
          textEditingController.text = summaryText;
        } else {
          textEditingController.text =
              "No summary available. Please try again.";
        }
      });
    } catch (error) {
      setState(() {
        textEditingController.text = "Error fetching summary: $error";
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _handleQuestions() async {
    if (summaryId == null) {
      showSnackBar(context, "Please upload a file first", Colors.red);
      return;
    }

    try {
      setState(() {
        isLoading = true;
        textEditingController.text = "Generating questions...";
      });

      // Add debug print before API call
      print('Calling API with summaryId: $summaryId');

      final questions = await apiServices.generateQuestions(
        context: context,
        summaryId: summaryId!,
        number: 10,
      );

      // Add debug print after API call
      print('API Response (questions): $questions');
      print('Response type: ${questions?.runtimeType}');

      if (questions != null && questions.isNotEmpty) {
        setState(() {
          textEditingController.text = questions.join("\n");
        });
      } else {
        setState(() {
          textEditingController.text =
              "No questions generated. Please try again.";
        });
      }
    } catch (error) {
      print('Error in _handleQuestions: $error');
      setState(() {
        textEditingController.text = "Error generating questions: $error";
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MyDrawer(),
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.edit, color: Colors.black, size: 20),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
        child: Column(
          children: [
            const SizedBox(height: TSizes.spaceBtwSections * 4),
            TextField(
              controller: textEditingController,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: TColors.primary),
                ),
                border: const OutlineInputBorder(),
                hintText:
                    'Upload a file to see the summary or generate questions',
              ),
              maxLines: 10,
              readOnly: true,
            ),
            const SizedBox(height: TSizes.spaceBtwSections * 1.5),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                onPressed: isLoading ? null : _handleUpload,
                child: isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text(TTexts.tUpload),
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    onPressed: isLoading ? null : _handleSummarize,
                    child: const Text(TTexts.tSummarize),
                  ),
                ),
                const SizedBox(width: TSizes.spaceBtwItems),
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    onPressed: isLoading ? null : _handleQuestions,
                    child: const Text(TTexts.tQuestionsandAnswers),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
