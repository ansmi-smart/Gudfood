page 50017 "Gudfood Order Subpage"
{
    Caption = 'Gudfood Order Subpage';
    PageType = ListPart;
    SourceTable = "Gudfood Order Line";
    AutoSplitKey = true;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Order No."; Rec."Order No.")
                {
                    ApplicationArea = All;
                    Visible = IsVisible;
                    ToolTip = 'Specifies the value of the Order No. field.';
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Line No. field.';
                }

                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Item No. field.';
                }
                field("Item Type"; Rec."Item Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Item Type field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Quantity field.';
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Unit Price field.';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Amount field.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Dimensions")
            {
                Image = Dimensions;
                trigger OnAction()
                begin
                    Rec.ShowDimensions();
                end;
            }
        }

    }

    var
        GudfoodOrderLine: Record "Gudfood Order Line";
        ShortcutDimCode: array[8] of Code[20];
        IsVisible: Boolean;

    procedure ValidateShortcutDimension(DimIndex: Integer)
    begin
        Rec.ValidateShortcutDimCode(DimIndex, ShortcutDimCode[DimIndex]);
        OnAfterValidateShortcutDimCode(Rec, ShortcutDimCode, DimIndex);
    end;

    procedure ChangeVisable(Status: Boolean)
    begin
        IsVisible := Status;
    end;

    LOCAL procedure OnAfterValidateShortcutDimCode(VAR GudfoodOrderLine: Record "Gudfood Order Line"; VAR ShortcutDimCode: ARRAY[8] OF Code[20]; DimIndex: Integer)
    begin
    end;
}
