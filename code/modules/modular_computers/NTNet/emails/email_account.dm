/datum/computer_file/data/email_account/
	var/list/inbox = list()
	var/list/outbox = list()
	var/list/spam = list()
	var/list/deleted = list()

	var/login = ""
	var/password = ""
	/// Whether you can log in with this account. Set to FALSE for system accounts.
	var/can_login = TRUE
	/// Whether the account is banned by the SA.
	var/suspended = FALSE
	var/connected_clients = list()

	var/fullname	= "N/A"
	var/assignment	= "N/A"

	var/notification_mute = FALSE

/datum/computer_file/data/email_account/calculate_size()
	size = 1
	for(var/datum/computer_file/data/email_message/stored_message in all_emails())
		stored_message.calculate_size()
		size += stored_message.size

/datum/computer_file/data/email_account/New()
	ntnet_global.email_accounts.Add(src)
	..()

/datum/computer_file/data/email_account/Destroy()
	ntnet_global.email_accounts.Remove(src)
	. = ..()

/datum/computer_file/data/email_account/proc/all_emails()
	return (inbox | spam | deleted)

/datum/computer_file/data/email_account/proc/send_mail(recipient_address, datum/computer_file/data/email_message/message, relayed = 0)
	var/datum/computer_file/data/email_account/recipient
	for(var/datum/computer_file/data/email_account/account in ntnet_global.email_accounts)
		if(account.login == recipient_address)
			recipient = account
			break

	if(!istype(recipient))
		return 0

	if(!recipient.receive_mail(message, relayed))
		return

	ntnet_global.add_log_with_ids_check("EMAIL LOG: [login] -> [recipient.login] title: [message.title].")
	return 1

/datum/computer_file/data/email_account/proc/receive_mail(datum/computer_file/data/email_message/received_message, relayed)
	received_message.set_timestamp()
	if(!ntnet_global.intrusion_detection_enabled)
		inbox.Add(received_message)
		return 1
	// Spam filters may occassionally let something through, or mark something as spam that isn't spam.
	if(received_message.spam)
		if(prob(98))
			spam.Add(received_message)
		else
			inbox.Add(received_message)
	else
		if(prob(1))
			spam.Add(received_message)
		else
			inbox.Add(received_message)
	return 1

// Address namespace (@internal-services.nt) for email addresses with special purpose only!.
/datum/computer_file/data/email_account/service/
	can_login = FALSE

/datum/computer_file/data/email_account/service/broadcaster/
	login = EMAIL_BROADCAST

/datum/computer_file/data/email_account/service/broadcaster/receive_mail(datum/computer_file/data/email_message/received_message, relayed)
	if(suspended || !istype(received_message) || relayed)
		return FALSE
	// Possibly exploitable for user spamming so keep admins informed.
	if(!received_message.spam)
		log_and_message_admins("Broadcast email address used by [usr]. Message title: [received_message.title].")

	spawn(0)
		for(var/datum/computer_file/data/email_account/email_account in ntnet_global.email_accounts)
			var/datum/computer_file/data/email_message/new_message = received_message.clone()
			send_mail(email_account.login, new_message, 1)
			sleep(2)

	return TRUE

/datum/computer_file/data/email_account/service/document
	login = EMAIL_DOCUMENTS

/datum/computer_file/data/email_account/service/sysadmin
	login = EMAIL_SYSADMIN

/datum/computer_file/data/email_account/service/broadcaster/receive_mail(datum/computer_file/data/email_message/received_message, relayed)
	if(!istype(received_message) || relayed)
		return 0
	// Possibly exploitable for user spamming so keep admins informed.
	if(!received_message.spam)
		log_and_message_admins("Broadcast email address used by [usr]. Message title: [received_message.title].")

	spawn(0)
		for(var/datum/computer_file/data/email_account/email_account in ntnet_global.email_accounts)
			var/datum/computer_file/data/email_message/new_message = received_message.clone()
			send_mail(email_account.login, new_message, 1)
			sleep(2)

	return 1
