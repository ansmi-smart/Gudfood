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
}
