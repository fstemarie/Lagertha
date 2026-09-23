#Requires AutoHotkey v2.0
#SingleInstance Force
SendMode("Input")
SetWorkingDir(A_ScriptDir)
SetKeyDelay(12)
SetTitleMatchMode(2)

#Include <toast>
#Include %A_ScriptDir%
#Include password.ahk
#Include anti_idle.ahk
#Include keep_alive.ahk

global sounds_dir := A_ScriptDir "\sounds\"
global pics_dir := A_ScriptDir "\pics\"
global client_phone := ""
global client_GCID := ""
global emojis := ["(hi)", "(highfive)", "(fistbump)", "(thumbsup)", "(party)", "(celebrate)", "(partypopper)", "(cool)",
    "(beamingfacewithsmilingeyes)"]
global START_SOUND := sounds_dir "start.mp3"
global hipics := [
    pics_dir "monkey1.jpg",
    pics_dir "monkey2.jpg",
    pics_dir "squirrel1.jpg",
    pics_dir "cat1.jpg",
    pics_dir "dog1.jpg",
    pics_dir "dog2.jpg",
    pics_dir "dog3.jpg",
    pics_dir "dog4.jpg",
    pics_dir "dog5.jpg",
    pics_dir "chevre1.webp"
]
global greetings := [
    "Buenos dias{!} ",
    "Hola{!} {emoji}",
    "Hey hey{!} {emoji}",
    "Salut{!} {emoji}",
    "Allo{!} {emoji}",
    "Coucou{!} {emoji}",
    "Hey ho{!} {emoji}",
    "(hi)",
    "(beamingfacewithsmilingeyes)",
    "(celebrate)",
    "(fistbump)",
    "(highfive)"
]

SoundPlay(START_SOUND)
toast("Starting trigger.ahk...", 1000)
OnClipboardChange(App_OnClipboardChange)

OnExit(App_OnExit)
App_OnExit(ExitReason, ExitCode)
{
    toast("Exiting...")
}

SendClip(message)
{
    OnClipboardChange(App_OnClipboardChange, 0)
    clipsaved := ClipboardAll()
    A_Clipboard := ""
    Sleep(100)
    A_Clipboard := message
    Send("^v")
    Sleep(100)
    A_Clipboard := clipsaved
    OnClipboardChange(App_OnClipboardChange, 1)
}

;-----------------------------------------------------------------------------------------------------------------------------
; OnClipboardChange
;-----------------------------------------------------------------------------------------------------------------------------
App_OnClipboardChange(DataType)
{
    SetTitleMatchMode(2)
    if WinActive("| Case | Salesforce")
    {
        if (DataType = 1)
        {
            currentClip := Trim(A_Clipboard, " `t`r`n")

            ; 1. 10-digit phone number (with or without dashes)
            if RegExMatch(currentClip, "^\(?\d{3}\)?[\s-.]?\d{3}[\s-.]?\d{4}$")
            {
                global client_phone := RegExReplace(currentClip, "[^0-9]")
                toast("Phone Captured: " . client_phone)
                Sleep(1000)
            }
            ; 2. 15-digit code
            else if RegExMatch(currentClip, "^\d{15}$")
            {
                global client_GCID := currentClip
                toast("15-digit GCID Captured: " . client_GCID)
                Sleep(1000)
            }
            ; 3. 14-digit code (prepend 0)
            else if RegExMatch(currentClip, "^\d{14}$")
            {
                global client_GCID := "0" . currentClip
                toast("14-digit GCID Captured: " . client_GCID)
                Sleep(1000)
            }
        }
    }
}

;-----------------------------------------------------------------------------------------------------------------------------
; Mouse buttons for switching virtual desktops
;-----------------------------------------------------------------------------------------------------------------------------

XButton2:: SendInput("^#{Left}")
XButton1:: SendInput("^#{Right}")
#q:: ExitApp()

;-----------------------------------------------------------------------------------------------------------------------------

^!r:: Reload
:*:ordianteur::ordinateur
:*:imprmiante::imprimante
:*:impriamnte::imprimante
:*:sebmle::semble
:*:tino::tion
:*:facturatino::facturation

;-----------------------------------------------------------------------------------------------------------------------------

::##fact::
{
    Send("Voici le numéro de téléphone pour rejoindre la facturation: 1-844-433-5778.")
}
::##port::
{
    Send("Voici l'addresse du portail pour la facturation https://www.bestbuy.ca/facturation")
}
::##how::
{
    Send("Comment puis-je vous aider ?")
}
::##sc::
{
    Send ("Pour le service à la clientèle, allez à la page: https://www.bestbuy.ca/fr-ca/aide/")
}
::##inhome::
{
    Send(
        "Voici le numéro pour rejoindre la GeekSquad: 1-844-433-5778.`nIl faut appeler et prendre rendez vous avec l'équipe de la GeekSquad à  domicile.`nVeuillez noter que le service est ouvert entre 8hAM et minuit, heure de l'est.`nNotez qu'il y aura des couts pour le déplacement qui dépenderont de la distance à ouvrir."
    )
}
::##abon::
{
    Send(
        "Vous pourrez vous abonner en allant à : https://www.bestbuy.ca/fr-ca/services/abonnement-best-buy/blt3e568aaafd01e95e"
    )
}
::##ass::
{
    Send(
        "Pour faire une réclamation, vous devez aller à l'addresse https://bbyc.assurantcustomerportal.com/fr-ca/home et remplir une demande"
    )
}
::##fait::
{
    Send("Dites `"fait`" lorsque ce sera fait svp.")
}

::#00#::
{
    OnClipboardChange(App_OnClipboardChange, 0)
    clipsaved := ClipboardAll()
    A_Clipboard := ""
    Sleep(100)
    A_Clipboard := "
    ( LTrim
        Bonjour! Je suis Agent Francois S.
        SVP. Donnez-moi un moment pendant que je vérifie la validité votre abonnement.
    )"
    Send("^v")
    Sleep(100)
    A_Clipboard := clipsaved
    OnClipboardChange(App_OnClipboardChange, 1)
}

::#10#::
{
    Send("J'ai bien trouvé votre abonnement. Comment puis-je vous aider?")
}
::#11#::
{
    Send("J'ai bien trouvé l'abonnement, mais je dois vous poser quelques questions afin de vérifier votre identité.")
}
::#12#::
{
    Send(
        "Je ne trouve aucun abonnement toujours valide à ce numéro/courriel.`nSi vous avez un abonnement Best Buy, j'aurais besoin du numéro de téléphone ou du courriel associé à  l'abonnement svp."
    )
}
::#13#::
{
    Send("Comment puis-je vous aider?")
}

::#40#::
{
    OnClipboardChange(App_OnClipboardChange, 0)
    clipsaved := ClipboardAll()
    A_Clipboard := ""
    Sleep(100)
    A_Clipboard := "
    ( LTrim
        Cliquez sur le lien qui va suivre. Démarrez le logiciel téléchargé puis acceptez les permissions
        Si le code est invalide, dites-le tout de suite
    )"
    Send("^v")
    Sleep(100)
    A_Clipboard := clipsaved
    OnClipboardChange(App_OnClipboardChange, 1)
}

::#41#::
{
    OnClipboardChange(App_OnClipboardChange, 0)
    clipsaved := ClipboardAll()
    A_Clipboard := ""
    Sleep(100)
    A_Clipboard := "
    ( LTrim
        Cliquez sur le lien qui va suivre. Démarrez le fichier téléchargé puis acceptez les permissions

        -----------------------------------
        https://secure.logmeinrescue.com/R?i=2&Code=
        -----------------------------------
        Si jamais le lien vous donne une erreur, dites-le tout de suite et donnez-moi les détails de l'erreur.
    )"
    Send("^v")
    Sleep(100)
    A_Clipboard := clipsaved
    OnClipboardChange(App_OnClipboardChange, 1)
}

#HotIf WinActive("ahk_class TeamsWebView")
:::b::
{
    rndEmoji := Random(1, emojis.Length)
    emoji := emojis[rndEmoji]
    rndGreeting := Random(1, greetings.Length)
    greeting := StrReplace(greetings[rndGreeting], "{emoji}", emoji)
    Send("{bs}" greeting)
}

:::bi::
{
    rndPic := Random(1, hipics.Length)
    ; LoadPicture returns an object in v2
    picObj := LoadPicture(hipics[rndPic])
    if (picObj)
    {
        OnClipboardChange(App_OnClipboardChange, 0)
        clipsaved := ClipboardAll()
        A_Clipboard := ""
        Sleep(200)
        picCopy := DllCall("CopyImage", "Ptr", picObj, "UInt", 0, "Int", 0, "Int", 0, "UInt", 0x0004, "Ptr")
        DllCall("OpenClipboard", "ptr", 0)
        DllCall("EmptyClipboard")
        DllCall("SetClipboardData", "uint", 2, "ptr", picCopy)  ; CF_BITMAP = 2
        DllCall("CloseClipboard")
        Sleep(200)
        Send("^v")
        Sleep(100)
        A_Clipboard := clipsaved
        ; DllCall context changes or object handle destruction is automatic,
        ; but keeping the explicit native execution:
        DllCall("DeleteObject", "ptr", picCopy)
        OnClipboardChange(App_OnClipboardChange, 1)
    }
}

:::atm::
{
    Send("Au revoir tout le monde{!}")
}

:::btm2::
{
    Send("Bonjour tout le monde{!}")
    rndPic := Random(1, hipics.Length)
    picObj := LoadPicture(hipics[rndPic])
    if (picObj)
    {
        OnClipboardChange(App_OnClipboardChange, 0)
        clipsaved := ClipboardAll()
        A_Clipboard := ""
        Sleep(200)
        picCopy := DllCall("CopyImage", "Ptr", picObj, "UInt", 0, "Int", 0, "Int", 0, "UInt", 0x0004, "Ptr")
        DllCall("OpenClipboard", "ptr", 0)
        DllCall("EmptyClipboard")
        DllCall("SetClipboardData", "uint", 2, "ptr", picCopy)
        DllCall("CloseClipboard")
        Sleep(200)
        Send("^v")
        Sleep(100)
        A_Clipboard := clipsaved
        DllCall("DeleteObject", "ptr", picCopy)
        OnClipboardChange(App_OnClipboardChange, 1)
    }
}

:::btm::
{
    Send("Bonjour tout le monde{!}")
    
    if (hipics.Length = 0)
        return
        
    rndPic := Random(1, hipics.Length)
    picPath := hipics[rndPic]
    
    if FileExist(picPath)
    {
        ; Temporarily disable clipboard listener
        OnClipboardChange(App_OnClipboardChange, 0)
        
        ; Save original clipboard
        clipsaved := ClipboardAll()
        
        ; Put the WebP file on the clipboard as a file drop (HDROP)
        if SetClipboardFile(picPath)
        {
            Sleep(150)
            Send("^v")
            Sleep(300) ; Brief delay to allow target app to process file paste
        }
        
        ; Restore original clipboard
        A_Clipboard := clipsaved
        OnClipboardChange(App_OnClipboardChange, 1)
    }
}

; Helper function: Puts a file path onto the clipboard using Win32 CF_HDROP
SetClipboardFile(filePath)
{
    ; Method A: Simple for-loop over the file pattern
    Loop Files, filePath, "F"
        filePath := A_LoopFileFullPath
    
    if !FileExist(filePath)
        return false

    ; Structure layout: DROPFILES (20 bytes header + null-terminated UTF-16 path)
    bufSize := 20 + StrLen(filePath) * 2 + 4
    hMem := DllCall("GlobalAlloc", "UInt", 0x42, "UPtr", bufSize, "UPtr")
    pMem := DllCall("GlobalLock", "UPtr", hMem, "UPtr")
    
    NumPut("UInt", 20, pMem, 0)  ; pFiles offset
    NumPut("UInt", 1,  pMem, 16) ; fWide = TRUE
    StrPut(filePath, pMem + 20, "UTF-16")
    
    DllCall("GlobalUnlock", "UPtr", hMem)
    
    if DllCall("OpenClipboard", "UPtr", 0)
    {
        DllCall("EmptyClipboard")
        DllCall("SetClipboardData", "UInt", 15, "UPtr", hMem) ; CF_HDROP = 15
        DllCall("CloseClipboard")
        return true
    }
    return false
}
#HotIf

::##suisla::
{
    Send("{Raw}https://www.youtube.com/clip/Ugkx6K1Ah7d6zhPwwfIwUgB0GCnMsT-kdIXt")
}

::##d::
{
    msg := "
    ( LTrim Join`n
        Demande du client:

        Numéro de téléphone: {1}
        GCID: {2}
    )"
    msg := Format(msg, client_Phone, client_GCID)
    SendClip(msg)
    ; client_phone := ""
    ; client_GCID := ""
}

::##r::
{
    SendClip("
	( LTrim
		Bonjour

		Merci encore de nous avoir accordé de votre temps aujourd'hui. Je voulais vous faire un bref résumé du travail accompli lors de votre séance avec nous.

		Au cours de notre session, nous avons:

		Si vous avez des questions ou si vous avez besoin d'aide pour quoi que ce soit d'autre, n'hésitez pas à  nous contacter. Nous sommes disponibles 24h/24 et 7j/7 au 
		https://www.geeksquad.ca/connectnow .

		Sincères salutations,
		Agent Francois S.
	)"
    )
}

::##rimp::
{
    SendClip("
	( LTrim
		Bonjour

		Merci encore pour votre temps aujourd'hui. Je voulais vous fournir un résumé rapide du travail effectué lors de la configuration de votre imprimante.
		Nous avons configuré votre imprimante via wifi, avec un test d'impression et un scan.
		Si vous avez des questions ou si vous avez besoin d'aide pour quoi que ce soit d'autre, n'hésitez pas à  nous contacter.
		Nous sommes disponibles 24h/24 et 7j/7 au

		https://www.geeksquad.ca/connectnow

		Sinceres salutations
		Agent Francois S.
	)"
    )
}

::##rcam::
{
    SendClip("
	( LTrim
		Bonjour!

		Merci encore de nous avoir accordé de votre temps aujourd'hui. Je voulais vous faire un bref résumé du travail accompli lors de votre séance avec nous.

		Nous avons réglé votre problème de caméra en la réactivant à  l'aide de la touche qui sert à  protéger votre vie privée. Cette touche désactive/active la caméra.

		Si vous avez des questions ou si vous avez besoin d'aide pour quoi que ce soit d'autre, n'hésitez pas à  nous contacter. Nous sommes disponibles 24h/24 et 7j/7 au 
		https://www.geeksquad.ca/connectnow

		Sincères salutations,
		Agent Francois S.
	)"
    )
}

::##config::
{
    SendClip("
	( LTrim
		Configuration initiale

		- Suppression applications inutiles: 
			* Assistance Rapide
			* Assistant de jeux
			* Contacts
			* Courrier et Calendrier
			* Family
			* Film et Tele
			* Hub de retroaction
			* Journal
			* Power Automate
			* Xbox
			* Xbox Live

		- Retrait Applications Demarrage: 
		- Connexion réseau Privée: 
		- Ajout icone GeekSquad sur bureau: 
		- Mises a jour: 

		BitDefender
		- Creer compte avec cx: 
		- Enlever antivirus deja installes: 
		- Installation/Config: 
		- Mises a jour: 
		- Optimization: 

		Chrome
		- Installation: 
		- Navigateur par defaut: 
		- Desactivation execution apres fermeture: 
		- Desactivation Notifications: 

		Edge
		- Desactivation execution apres fermeture: 
		- Desactivation Notifications: 

		Additionnel
		- Installation Acrobat Reader: 
		- Installation/Activation Office: 
		- Installation Imprimante: 
		- Configuration Email: 
	)"
    )
}

::##tuneup::
{
    SendClip("
    ( LTrim
        https://bestbuycanada.lightning.force.com/lightning/articles/Knowledge_Base/Remote-Services-Scope-of-Work-Tune-Up
        Test de vitesse: test de vitesse http://geeksquad.speedtestcustom.com

        Résultats du service :

        Redémarrage initial terminé :
        Programmes supprimés :
            * Acronis
            * Assistance Rapide
            * Assistant de jeux
            * Bitdefender VPN
            * Compagnon de la console Xbox
            * Contacts
            * Courrier et Calendrier
            * Family
            * Film et Tele
            * Hub de retroaction
            * Paint 3D
            * Power Automate
            * Print 3D
            * Visionneuse 3D
            * Xbox
            * Xbox Live

            * Acer Jumpstart
            * Acer product reg
            * App Explorer
            * Cortana
            * Disney+
            * Dropbox - Offre promotionnelle
            * Evernote
            * Google play games beta
            * Java
            * Omen Gaming Hub
            * PC Helpsoft driver updater
            * Silverlight
            * Skype
            * Web Advisor McAfee
        Fichiers temporaires supprimés (via FACE ou OnyX) :
        Éléments de démarrage désactivés :
        Plan d'alimentation :
        Cache du navigateur supprimé :
        Paramètres du navigateur modifiés :
        Optimisation de la livraison des mises à  jour désactivée :
        Mises à jour appliquées :
        Vérification de l'antivirus :
    )"
    )
}

::##cimp::
{
    SendClip("
	( LTrim
		Configuration de l'imprimante

		Imprimante a été ajoutée à  l'ordinateur via [Logiciel de pilote complet ou autre] :
		wifi
		pilotes fabricant

		Si une configuration manuelle est nécessaire, étapes suivies :

		Numérisation testée (O/N) : O
	)"
    )
}

::##cimp2::
{
    SendClip("
	( LTrim
		Configuration imprimante

		Imprimante a été ajoutée à  l'ordinateur via:
		# Méthode de connexion:
		- WIFI
		- Cable usb
		- Ethernet
		- WIFI-Direct
		- Bluetooth

		# Méthode d'installation:
		- Installateur du fabricant
		- HP Smart
		- Windows Update
		- MOPRIA
		- AirPrint

		Si une configuration manuelle est nécessaire, étapes suivies :
		# Etapes supplémentaires dignes de mention:
		- Enlevé enregistrements d'imprimantes inexistantes
		- Enlevé logiciels/pilotes d'imprimantes inexistantes
		- Fait redémarrer l'imprimante et le routeur wifi
		- Enlevé/Réenregistré imprimante dans Système d'impression.
		- Installé version alternative des pilotes du fabricant
		- Problème avec logiciel de numérisation.
		Installé alternative
		- Connecté imprimante au wifi via câble USB
		- Connecté imprimante au wifi via câble WIFI-Direct
		- Connecté imprimante au wifi via panneau de commande par client
		- Connecté imprimante au wifi en faisant maintenir bouton X/Wifi/Chaînon

		Numérisation testée (O/N) :
		- Oui
		- Non
	)"
    )
}

::##cvirus::
{
    SendClip("
	( LTrim
		# Vérification de la sécurité

		- Faire accepter décharge par le client:
		- Vérifié processus en cours:
		- Vérifié les notifications système:
		- Vérifié notifications antivirus:
		- Vérifié applications fraîchement installées:
		- Vérifié téléchargements récents:
		- Vérifié historique du navigateur:
		- Désactivé notifications du navigateur:
		- Vérifié si courriels redirigés (règles/transfer):
	)"
    )
}

::##cpirate::
{
    SendClip("
	( LTrim
		# Compte courriel piraté

		- Changé mot de passe: 
		- Vérifié si courriels redirigés (règles/transfer):
		- Vérifié Courriel et téléphone de récupération: 
		- Déconnecté toutes connexions du compte: 
		- Active 2FA: 
	)"
    )
}

::##ccam::
{
    SendEvent("
		( LTrim
			# Activation de la caméra

			- Montré au client comment activer/desactiver sa camera via la touche du clavier
			- Réinstallé pilote
		)"
    )
}
