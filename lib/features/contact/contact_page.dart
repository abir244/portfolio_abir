import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../core/constants/constants.dart';
import '../../core/theme/theme.dart';
import '../../core/utils/utils.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtr = TextEditingController();
  final _emailCtr = TextEditingController();
  final _subjCtr = TextEditingController();
  final _msgCtr = TextEditingController();
  bool _sending = false;

  @override
  void dispose() {
    _nameCtr.dispose();
    _emailCtr.dispose();
    _subjCtr.dispose();
    _msgCtr.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _sending = true);
    await Future.delayed(const Duration(seconds: 2)); // simulate API call
    setState(() => _sending = false);
    if (!mounted) return;
    showSnack(context, '✅ Message sent! I\'ll reply within 24 hours.');
    _nameCtr.clear();
    _emailCtr.clear();
    _subjCtr.clear();
    _msgCtr.clear();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isDesktop = ResponsiveLayout.isDesktop(context);
    final padding = ResponsiveLayout.pagePadding(context);

    return Scaffold(
      appBar: AppBar(
        title: ShaderMask(
          shaderCallback: (b) =>
              const LinearGradient(colors: AppColors.heroGradient)
                  .createShader(b),
          child: const Text('Contact',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 20)),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_rounded,
              color: isDark ? Colors.white : AppColors.textDark),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1280),
            child: Padding(
              padding: padding,
              child: isDesktop
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 2, child: _LeftPanel(isDark: isDark)),
                        const SizedBox(width: 60),
                        Expanded(
                            flex: 3,
                            child: _ContactForm(
                                formKey: _formKey,
                                nameCtr: _nameCtr,
                                emailCtr: _emailCtr,
                                subjCtr: _subjCtr,
                                msgCtr: _msgCtr,
                                sending: _sending,
                                onSubmit: _submit,
                                isDark: isDark)),
                      ],
                    )
                  : Column(children: [
                      _LeftPanel(isDark: isDark),
                      const SizedBox(height: 48),
                      _ContactForm(
                          formKey: _formKey,
                          nameCtr: _nameCtr,
                          emailCtr: _emailCtr,
                          subjCtr: _subjCtr,
                          msgCtr: _msgCtr,
                          sending: _sending,
                          onSubmit: _submit,
                          isDark: isDark),
                    ]),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
class _LeftPanel extends StatelessWidget {
  final bool isDark;
  const _LeftPanel({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return FadeInLeft(
      duration: const Duration(milliseconds: 700),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          _sectionLabel(),
          const SizedBox(height: 12),
          Text("Let's talk.", style: tt.displaySmall),
          const SizedBox(height: 16),
          Text(
            'Got a project in mind, an opportunity to share, or just want to say hi? '
            'Fill in the form and I\'ll get back to you within 24 hours.',
            style: tt.bodyLarge,
          ),
          const SizedBox(height: 40),

          _ContactInfoRow(
            icon: Icons.email_outlined,
            label: 'Email',
            value: AppConstants.email,
            onTap: () => launchURL('mailto:${AppConstants.email}'),
          ),
          const SizedBox(height: 16),
          _ContactInfoRow(
            icon: Icons.phone_outlined,
            label: 'Phone',
            value: AppConstants.phone,
            onTap: () => launchURL('tel:${AppConstants.phone}'),
          ),
          const SizedBox(height: 16),
          _ContactInfoRow(
            icon: Icons.location_on_outlined,
            label: 'Location',
            value: AppConstants.location,
          ),
          const SizedBox(height: 40),

          // Social icons
          Text('Find me on', style: tt.labelLarge),
          const SizedBox(height: 16),
          Row(children: [
            _SocialBtn(
                icon: FontAwesomeIcons.github,
                url: AppConstants.githubUrl,
                tooltip: 'GitHub'),
            _SocialBtn(
                icon: FontAwesomeIcons.linkedin,
                url: AppConstants.linkedinUrl,
                tooltip: 'LinkedIn'),
            _SocialBtn(
                icon: FontAwesomeIcons.twitter,
                url: AppConstants.twitterUrl,
                tooltip: 'Twitter'),
            _SocialBtn(
                icon: FontAwesomeIcons.dribbble,
                url: AppConstants.dribbbleUrl,
                tooltip: 'Dribbble'),
          ]),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _sectionLabel() => Row(children: [
        Container(
            width: 4,
            height: 18,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                  colors: AppColors.heroGradient,
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter),
              borderRadius: BorderRadius.circular(2),
            )),
        const SizedBox(width: 10),
        const Text('CONTACT',
            style: TextStyle(
                color: AppColors.primary,
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 2)),
      ]);
}

class _ContactInfoRow extends StatefulWidget {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback? onTap;
  const _ContactInfoRow(
      {required this.icon,
      required this.label,
      required this.value,
      this.onTap});

  @override
  State<_ContactInfoRow> createState() => _ContactInfoRowState();
}

class _ContactInfoRowState extends State<_ContactInfoRow> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = widget.onTap != null),
      onExit: (_) => setState(() => _hovered = false),
      cursor:
          widget.onTap != null ? SystemMouseCursors.click : MouseCursor.defer,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _hovered
                ? AppColors.primary.withOpacity(0.08)
                : isDark
                    ? AppColors.darkCard
                    : AppColors.lightCard,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: _hovered
                  ? AppColors.primary
                  : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
            ),
          ),
          child: Row(children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: AppColors.heroGradient),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(widget.icon, size: 18, color: Colors.white),
            ),
            const SizedBox(width: 14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.label,
                    style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 11,
                        fontWeight: FontWeight.w700)),
                const SizedBox(height: 2),
                Text(widget.value,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: isDark ? Colors.white : AppColors.textDark,
                    )),
              ],
            ),
          ]),
        ),
      ),
    );
  }
}

class _SocialBtn extends StatefulWidget {
  final IconData icon;
  final String url, tooltip;
  const _SocialBtn(
      {required this.icon, required this.url, required this.tooltip});

  @override
  State<_SocialBtn> createState() => _SocialBtnState();
}

class _SocialBtnState extends State<_SocialBtn> {
  bool _hovered = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: Tooltip(
        message: widget.tooltip,
        child: GestureDetector(
          onTap: () => launchURL(widget.url),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: _hovered
                  ? const LinearGradient(colors: AppColors.heroGradient)
                  : null,
              color: _hovered ? null : AppColors.darkCard,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _hovered ? Colors.transparent : AppColors.darkBorder,
              ),
              boxShadow: _hovered
                  ? [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      )
                    ]
                  : null,
            ),
            child: FaIcon(widget.icon, size: 16, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
class _ContactForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameCtr, emailCtr, subjCtr, msgCtr;
  final bool sending;
  final VoidCallback onSubmit;
  final bool isDark;

  const _ContactForm({
    required this.formKey,
    required this.nameCtr,
    required this.emailCtr,
    required this.subjCtr,
    required this.msgCtr,
    required this.sending,
    required this.onSubmit,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return FadeInRight(
      duration: const Duration(milliseconds: 700),
      child: Container(
        padding: const EdgeInsets.all(36),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : AppColors.lightCard,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
              color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.25 : 0.06),
              blurRadius: 24,
              offset: const Offset(0, 8),
            )
          ],
        ),
        child: Form(
          key: formKey,
          child: Column(children: [
            Row(children: [
              Expanded(
                  child: _Field(
                      ctrl: nameCtr,
                      label: 'Full Name',
                      hint: 'John Doe',
                      icon: Icons.person_outline)),
              const SizedBox(width: 16),
              Expanded(
                  child: _Field(
                ctrl: emailCtr,
                label: 'Email',
                hint: 'john@example.com',
                icon: Icons.email_outlined,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Enter your email';
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v))
                    return 'Enter a valid email';
                  return null;
                },
              )),
            ]),
            const SizedBox(height: 20),
            _Field(
                ctrl: subjCtr,
                label: 'Subject',
                hint: "I'd like to discuss...",
                icon: Icons.subject_rounded),
            const SizedBox(height: 20),
            _Field(
              ctrl: msgCtr,
              label: 'Message',
              hint: 'Tell me about your project, timeline, and budget...',
              icon: Icons.message_outlined,
              maxLines: 6,
              validator: (v) {
                if (v == null || v.isEmpty) return 'Enter your message';
                if (v.length < 20) return 'Message is too short (min 20 chars)';
                return null;
              },
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: sending ? null : onSubmit,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  padding: EdgeInsets.zero,
                ).copyWith(
                  backgroundColor: WidgetStateProperty.all(Colors.transparent),
                  shadowColor: WidgetStateProperty.all(Colors.transparent),
                ),
                child: Ink(
                  decoration: BoxDecoration(
                    gradient:
                        const LinearGradient(colors: AppColors.heroGradient),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: sending
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2.5),
                          )
                        : const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.send_rounded,
                                  size: 18, color: Colors.white),
                              SizedBox(width: 10),
                              Text('Send Message',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15)),
                            ],
                          ),
                  ),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  final TextEditingController ctrl;
  final String label, hint;
  final IconData icon;
  final int maxLines;
  final String? Function(String?)? validator;

  const _Field({
    required this.ctrl,
    required this.label,
    required this.hint,
    required this.icon,
    this.maxLines = 1,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: ctrl,
      maxLines: maxLines,
      validator: validator ??
          (v) => (v == null || v.isEmpty) ? 'This field is required' : null,
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: maxLines == 1
            ? Icon(icon, size: 18, color: AppColors.primary)
            : null,
        alignLabelWithHint: maxLines > 1,
        contentPadding: EdgeInsets.symmetric(
            horizontal: 16, vertical: maxLines > 1 ? 16 : 0),
      ),
    );
  }
}
