codeunit 50000 WizardSubscriber
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Guided Experience", 'OnRegisterAssistedSetup', '', false, false)]
    local procedure AddFieldInsertionWizard()
    var
        AssistedSetup: Codeunit "Guided Experience";
        Language: Codeunit Language;
        CurrentGlobalLanguage: Integer;
    begin
        CurrentGlobalLanguage := GlobalLanguage;
        AssistedSetup.InsertAssistedSetup(SetupTxt, SetupTxt, SetupTxt, 1000, ObjectType::Page, 50055,
                        "Assisted Setup Group"::GettingStarted, '',
                        "Video Category"::Uncategorized, '');

        GlobalLanguage(Language.GetDefaultApplicationLanguageId());
        AssistedSetup.AddTranslationForSetupObjectDescription("Guided Experience Type"::"Assisted Setup", ObjectType::Page, 50055, Language.GetDefaultApplicationLanguageId(), SetupTxt);
        GlobalLanguage(CurrentGlobalLanguage);
    end;

    local procedure GetAppId(): Guid
    var
        EmptyGuid: Guid;
    begin
        if Info.Id() = EmptyGuid then
            NavApp.GetCurrentModuleInfo(Info);
        exit(Info.Id());
    end;

    var
        Info: ModuleInfo;
        SetupTxt: Label 'Set up Cust. Post. Description ANSMI';
}
