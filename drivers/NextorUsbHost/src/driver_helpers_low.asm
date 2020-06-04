
	STRUCT _SCSI_DEVINFO
BASE:				; Offset to the base of the data structure
VENDORID:			ds 8 ;UINT8	VendorIdStr[8];				/* 08H */
					db 0
PRODUCTID:			ds 16 ;UINT8 ProductIdStr[16];			/* 10H */
					db 0
PRODUCTREV:			ds 8 ;UINT8	ProductRevStr[4];			/* 20H */ 
					db 0
	ENDS

	STRUCT _USB_DEVICE_INFO
BASE:
DEVICE_ADDRESS					DB
NUM_CONFIGS						DB
NUM_INTERFACES					DB
NUM_ENDPOINTS					DB
WANTED_CLASS					DB
WANTED_SUB_CLASS				DB
WANTED_PROTOCOL					DB
INTERFACE_ID					DB
CONFIG_ID						DB
MAX_PACKET_SIZE					DB
DATA_BULK_IN_ENDPOINT_ID		DB
DATA_BULK_OUT_ENDPOINT_ID		DB
DATA_BULK_IN_ENDPOINT_TOGGLE	DB
DATA_BULK_OUT_ENDPOINT_TOGGLE	DB
HUB_PORTS						DB
HUB_PORT_STATUS					DS 4
	ENDS

	STRUCT WRKAREA
BASE:					; Offset to the base of the data structure 
STATUS:					db ; bit 0 = CH376s present, bit 1 = initialised, bit 2 = USB device present, bit 3 = USB device mounted, bit 5 = DSK changed
MAX_DEVICE_ADDRESS:		db 0
USB_DEVICE_INFO:		_USB_DEVICE_INFO
SCSI_DEVICE_INFO:		_SCSI_DEVINFO
SCSI_TAG				DB
SCSI_BUFFER:    		ds 0x24 ; longest response (inquiry) we want to absorb during init
SCSI_CSW:				ds _SCSI_COMMAND_STATUS_WRAPPER
USB_DESCRIPTOR			ds 140 ; memory area to hold the usb device+config descriptor of the current interrogated device
USB_DESCRIPTORS			ds USB_DESCRIPTORS_END - USB_DESCRIPTORS_START
NXT_DIRECT				ds NXT_DIRECT_END - NXT_DIRECT_START
JUMP_TABLE				ds JUMP_TABLE_END - JUMP_TABLE_START
	ENDS

TXT_START:              db "Starting CH376s driver v0.5\r\n",0,"$"
TXT_FOUND:              db "+MSXUSB connected\r\n",0,"$"
TXT_NOT_FOUND:          db "-MSXUSB NOT connected\r\n",0,"$"
TXT_NEWLINE				db "\r\n",0,"$"
TXT_DEVICE_CHECK_OK:	db " device(s) connected\r\n",0,"$"
TXT_DEVICE_CHECK_NOK:	db "-No USB device connected\r\n",0,"$"
TXT_STORAGE_CHECK_NOK:	db "-No USB storage\r\n",0,"$"
TXT_STORAGE_CHECK_OK:	db "+USB Storage:",0,"$"
TXT_INQUIRY_OK:			db "\r\n- ",0,"$"
TXT_INQUIRY_NOK:		db "\r\n-Error (Inquiry)\r\n",0,"$"
TXT_TEST_START:			db "\r\n+Storage coming online",0,"$"
TXT_TEST_OK:			db "\r\n+Booting...\r\n",0,"$"