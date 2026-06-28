import 'package:learnwayv2/app/app_barrel.dart';

class AccountSections extends StatelessWidget {
  final List<Widget> children;
  final EdgeInsetsGeometry? padding;

  const AccountSections({super.key, required this.children, this.padding});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              for (int i = 0; i < children.length; i++) ...[
                children[i],
                if (i < children.length - 1)
                  const Divider(height: 1, indent: 20, endIndent: 20),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class AccountImageTile extends StatelessWidget {
  final String imageUrl;
  final String username;
  final String email;
  final VoidCallback? onImageTap;

  const AccountImageTile({
    super.key,
    required this.imageUrl,
    required this.username,
    required this.email,
    this.onImageTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
      child: Row(
        children: [
          GestureDetector(
            onTap: onImageTap,
            child: CircleAvatar(
              radius: 30,
              backgroundImage: _getImageProvider(imageUrl),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                ),
              ),
            ),
          ),
          const HSpace(10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(username, style: AppTextStyles.lgSemiBold(context)),
                const SizedBox(height: 4),
                Text(email, style: AppTextStyles.smRegular(context)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ImageProvider _getImageProvider(String imageUrl) {
    if (imageUrl.startsWith('assets/')) {
      return AssetImage(imageUrl);
    } else if (imageUrl.startsWith('http')) {
      return NetworkImage(imageUrl);
    } else {
      return NetworkImage(imageUrl);
    }
  }
}

class AccountTiles extends StatelessWidget {
  const AccountTiles({
    super.key,
    required this.title,
    required this.icon,
    this.padding,
    this.onTap,
  });

  final String title;
  final VoidCallback? onTap;
  final String icon;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: padding ?? const EdgeInsets.fromLTRB(20, 15, 20, 15),
        child: Row(
          children: [
            SvgPicture.asset(icon),
            const HSpace(10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.smRegular(context)),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: AppColors.gray600),
          ],
        ),
      ),
    );
  }
}

class SocialTile extends StatelessWidget {
  const SocialTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.onTap,
  });

  final String title;
  final String subtitle;
  final String icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        child: Row(
          children: [
            SvgPicture.asset(icon),
            HSpace(16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [Text(title, style: AppTextStyles.sm(context))],
              ),
            ),
            Icon(Icons.chevron_right, color: AppColors.gray600),
          ],
        ),
      ),
    );
  }
}

class IndependentTile extends StatelessWidget {
  const IndependentTile({
    super.key,
    required this.icon,
    required this.title,
    this.styles,
    this.onTap,
    this.showArrow = true,
    this.backgroundColor,
    this.countryFlag,
  });
  final String icon;
  final String title;
  final VoidCallback? onTap;
  final TextStyle? styles;
  final bool showArrow;
  final Color? backgroundColor;
  final Widget? countryFlag;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          child: Row(
            children: [
              if (countryFlag != null) ...[
                SizedBox(width: 24, height: 16, child: countryFlag),
                const HSpace(4),
              ] else if (icon.isNotEmpty) ...[
                SvgPicture.asset(icon),
                const HSpace(10),
              ] else ...[
                SizedBox.shrink(),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: styles ?? AppTextStyles.sm(context)),
                  ],
                ),
              ),
              if (showArrow)
                Icon(Icons.chevron_right, color: AppColors.gray600),
            ],
          ),
        ),
      ),
    );
  }
}
