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
                    // ImportFromDevice;
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
        Camera: Codeunit Camera;
        [InDataSet]
        CameraAvailable: Boolean;
        DeleteImageQst: Label 'Are you sure you want to delete the picture?';
        SelectPictureTxt: Label 'Select a picture to upload';
        DeleteExportEnabled: Boolean;
        HideActions: Boolean;

    /*   [Scope('OnPrem')]
       procedure ImportFromDevice()
       var
           FileManagement: Codeunit "File Management";
           FileName: Text;
           ClientFileName: Text;
       begin
           Rec.Find;
           Rec.TestField(Code);

           ClientFileName := '';
           FileName := FileManagement.UploadFile(SelectPictureTxt, ClientFileName);
           if FileName = '' then
               Error('');

           Clear(Rec.Picture);
           Rec.Picture.ImportFile(FileName, ClientFileName);
           Rec.Modify(true);

           if FileManagement.DeleteServerFile(FileName) then;
       end;*/

    procedure DeleteItemPicture()
    begin
        Rec.TestField(Code);

        if not Confirm(DeleteImageQst) then
            exit;

        Clear(Rec.Picture);
        Rec.Modify(true);
    end;
}
