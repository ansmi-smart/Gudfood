page 50014 "Gudfood Item Picture"
{
    Caption = 'Gudfood Item Picture';
    PageType = CardPart;
    SourceTable = "Gudfood Item";

    layout
    {
        area(content)
        {
            group(General)
            {
                CaptionML = RUS = 'Общее';
                field(Picture; Rec.Picture)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Picture field.';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {

            action(ImportPicture)
            {
                ApplicationArea = All;
                Caption = 'Import';
                Image = Import;
                ToolTip = 'Import a picture file.';
                Visible = HideActions = FALSE;

                trigger OnAction()
                begin
                    ImportFromDevice;
                end;
            }
            action(DeletePicture)
            {
                ApplicationArea = All;
                Caption = 'Delete';
                Image = Delete;
                ToolTip = 'Delete the record.';

                trigger OnAction()
                begin
                    DeleteItemPicture;
                end;
            }

        }
    }

    var

        DeleteImageQst: Label 'Are you sure you want to delete the picture?';
        SelectPictureTxt: Label 'Select a picture to upload';
        OverrideImageQst: Label 'The existing picture will be replaced. Do you want to continue?';

        HideActions: Boolean;

    [Scope('OnPrem')]
    procedure ImportFromDevice()
    var
        FileManagement: Codeunit "File Management";
        FileName: Text;
        ClientFileName: Text;
        sf: page "Item Picture";
    begin
        Rec.Find;
        Rec.TestField(Code);

        if Picture.HasValue then
            if not Confirm(OverrideImageQst) then
                Error('');

        ClientFileName := '';
        FileName := FileManagement.UploadFile(SelectPictureTxt, ClientFileName);
        if FileName = '' then
            Error('');

        Clear(Rec.Picture);
        Rec.Picture.ImportFile(FileName, ClientFileName);
        Rec.Modify(true);
        OnImportFromDeviceOnAfterModify(Rec);

        if FileManagement.DeleteServerFile(FileName) then;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnImportFromDeviceOnAfterModify(var GudfoodItem: Record "Gudfood Item")
    begin
    end;

    procedure DeleteItemPicture()
    begin
        Rec.TestField(Code);

        if not Confirm(DeleteImageQst) then
            exit;

        Clear(Rec.Picture);
        Rec.Modify(true);
    end;
}
