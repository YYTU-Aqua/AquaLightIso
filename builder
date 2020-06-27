#!/bin/sh
zenity --question --width 350 --text "これはまだ開発段階ですそれでも続けますか？" --ok-label "OK" cancel-label "No"
case $? in
0) main=$(zenity --width 700 --height 320 --list --title "操作を選んでね" --text="操作を選んでね" --column "" setup 背景の設定 Calamaresの設定 パッケージの設定 GRUBの背景 GRUB表示名 LightDM LiveCDusername build)
;;
1) exit
;;
esac
case $main in
setup) cd channels
git clone https://github.com/YYTU-Aqua/AquaLightOS.git
cd ../
cp -f -r channels/AquaLightOS/aqua.add channels
sudo sh builder
;;
背景の設定) file=$(zenity --file-selection --title "ファイルを選んで下さい")
echo $file
sudo rm channels/aqua.add/airootfs.any/usr/share/backgrounds/Aqua.jpg
sudo cp -f $file channels/aqua.add/airootfs.any/usr/share/backgrounds/Aqua.jpg
mv $file Aqua.jpg
sudo sh builder
;;
Calamaresの設定) zenity --width 350 --info --title "info" --text "写真やbranding.descを編集してください"
sudo thunar channels/aqua.add/airootfs.any/usr/share/#/branding/alter
sudo sh builder
;;
パッケージの設定) zenity --width 350 --info --title "info" --text "基本的には自動取得なので自分の今入れてないパッケージを使いたいときにお使いください"
sudo medit channels/aqua.add/packages.x86_64/packages.x86_64
sudo sh builder
;;
GRUBの背景)sp=$(zenity --file-selection --title "ファイルを選んで下さい")
sudo cp $sp channels/aqua.add/splash.png
sudo sh builder
;;
GRUB表示名) sudo medit channels/aqua.add/airootfs.any/etc/default/grub
sudo sh builder
;;
LightDM) zenity --width 350 --info --title "info" --text "GRUB_DISTRIBUTOR= を編集してください"
 sudo medit channels/aqua.add/airootfs.any/etc/lightdm/lightdm.conf
sudo sh builder
;;
LiveCDusername) zenity --width 350 --forms --add-entry "ユーザー名" >user
name=$(<user)
sudo sh builder
;;
build)use=$(zenity --width 350 --forms --add-entry "あなたのusernameは？")
sudo cp -f -r /etc/lightdm channels/aqua.add/airootfs.any/etc/
sudo sed -i 's/alter*/#/g' channels/aqua.add/packages.x86_64/packages.x86_64
sudo sed -i 's/calamares/#/g' channels/aqua.add/packages.x86_64/packages.x86_64
sudo cp -f -r /usr/share/lightdm-webkit channels/aqua.add/airootfs.any/usr/share/lightdm-webkit
pacman -Qqe | grep -v "$(pacman -Qmq)" > channels/aqua.add/packages.x86_64/packages.x86_64
sudo rm -r -f channels/aqua.add/airootfs.any/etc/skel/
sudo mkdir channels/aqua.add/airootfs.any/etc/skel
sudo cp -f -r /home/$use/.config channels/aqua.add/airootfs.any/etc/skel/
sudo cp -f -r /home/$use/.local channels/aqua.add/airootfs.any/etc/skel/
sudo rm -f -r channels/aqua.add/airootfs.any/etc/skel/.config/desktop
sudo rm -f -r channels/aqua.add/airootfs.any/usr/share/themes/
sudo cp -r -f /usr/share/themes channels/aqua.add/airootfs.any/usr/share/
sudo rm -f -r channels/aqua.add/airootfs.any/usr/share/icons/
sudo cp -r -f /usr/share/icons channels/aqua.add/airootfs.any/usr/share/
sudo ./build.sh -b -u $name -j aqua
;;
*) exit
;;
esac