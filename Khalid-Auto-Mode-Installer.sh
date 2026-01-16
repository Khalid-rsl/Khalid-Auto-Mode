#!/bin/bash
# Developed by Khalid Rasul (Khalid_RSL)
# ⚖️ License: MIT License - Personal & Non-Commercial Use [cite: 1]
# ⚖️ License: This project is licensed under the MIT License - see the LICENSE file for details. 

# تعريف الألوان (التنسيق الاحترافي)
G='\033[0;32m' # الأخضر
B='\033[0;34m' # الأزرق
Y='\033[1;33m' # الأصفر
C='\033[0;36m' # السماوي
NC='\033[0m'    # اللون الطبيعي

clear

# واجهة الشعار المرتبة مع توثيق الترخيص الكامل
echo -e "${B}############################################################${NC}"
echo -e "${B}#${NC}                                                          ${B}#${NC}"
echo -e "${B}#${NC}    ${C}██╗  ██╗██╗  ██╗ █████╗ ██╗     ██╗██████╗ ${NC}        ${B}#${NC}"
echo -e "${B}#${NC}    ${C}██║ ██╔╝██║  ██║██╔══██╗██║     ██║██╔══██╗${NC}        ${B}#${NC}"
echo -e "${B}#${NC}    ${C}█████╔╝ ███████║███████║██║     ██║██║  ██║${NC}        ${B}#${NC}"
echo -e "${B}#${NC}    ${C}██╔═██╗ ██╔══██║██╔══██║██║     ██║██║  ██║${NC}        ${B}#${NC}"
echo -e "${B}#${NC}    ${C}██║  ██╗██║  ██║██║  ██║███████╗██║██████╔╝${NC}        ${B}#${NC}"
echo -e "${B}#${NC}    ${C}╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚═╝╚═════╝ ${NC}        ${B}#${NC}"
echo -e "${B}#${NC}                                                          ${B}#${NC}"
echo -e "${B}#${NC}  ${Y}        >>> KHALID - AUTO - MODE (RSL) <<<      ${NC}        ${B}#${NC}"
echo -e "${B}#${NC}  ${G}    License: MIT - Personal & Non-Commercial Use    ${NC}    ${B}#${NC}"
echo -e "${B}#${NC}  ${C}    See LICENSE file for full legal details         ${NC}    ${B}#${NC}"
echo -e "${B}############################################################${NC}"
echo -e "${G}  [+] Status: System Check... [جاري فحص النظام]${NC}"
echo -e "  [+] Developer: Khalid_RSL | 🦅 High-Vision Tools"
echo -e "${B}------------------------------------------------------------${NC}"

# 1. إعداد الملفات [cite: 6]
echo -e "${C}[1/5]${NC} Preparing files... [إعداد الملفات]"
sudo cp /etc/X11/xorg.conf /etc/X11/xorg.conf.custom 2>/dev/null
sudo touch /etc/X11/xorg.conf.empty

# 2. إنشاء السكربت الذكي [cite: 5]
echo -e "${C}[2/5]${NC} Creating Smart Switcher... [إنشاء السكربت الذكي]"
sudo tee /usr/local/bin/graphics-switcher > /dev/null <<EOF
#!/bin/bash
if lspci | grep -Ei 'nvidia|vga|graphics' | grep -v 'Intel' > /dev/null; then
    ln -sf /etc/X11/xorg.conf.custom /etc/X11/xorg.conf
else
    ln -sf /etc/X11/xorg.conf.empty /etc/X11/xorg.conf
fi
EOF
sudo chmod +x /usr/local/bin/graphics-switcher

# 3. جلب بيانات النظام [cite: 2, 3]
echo -e "${C}[3/5]${NC} Fetching System UUID & Kernel... [جلب البيانات]"
LATEST_VMLINUZ=\$(ls -v /boot/vmlinuz-* | tail -n 1 | xargs basename)
LATEST_INITRD=\$(ls -v /boot/initrd.img-* | tail -n 1 | xargs basename)
CURRENT_UUID=\$(grub-probe --target=fs_uuid /)

# 4. بناء قائمة الجراب [cite: 1, 4]
echo -e "${C}[4/5]${NC} Configuring GRUB Menu... [إعداد قائمة الإقلاع]"
sudo tee /etc/grub.d/40_custom > /dev/null <<EOF
#!/bin/sh
exec tail -n +3 \$0
menuentry 'KALI - Auto Mode (Khalid_RSL)' {
    search --no-floppy --fs-uuid --set=root $CURRENT_UUID
    linux /boot/$LATEST_VMLINUZ root=UUID=$CURRENT_UUID ro quiet splash khalid_mode
    initrd /boot/$LATEST_INITRD
}
EOF

# 5. التفعيل النهائي [cite: 4, 7]
echo -e "${C}[5/5]${NC} Finalizing... [تحديث النظام]"
(crontab -l 2>/dev/null | grep -v "graphics-switcher"; echo "@reboot /usr/local/bin/graphics-switcher") | sudo crontab -
sudo update-grub > /dev/null 2>&1
sudo update-initramfs -u -k all > /dev/null 2>&1

echo -e "${B}------------------------------------------------------------${NC}"
echo -e "${G}SUCCESS: KHALID-AUTO-MODE is now installed!${NC}"
echo -e "${Y}Please reboot and select the new entry from GRUB.${NC}"
echo -e "${B}############################################################${NC}"
