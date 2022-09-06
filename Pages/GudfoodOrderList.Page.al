page 50021 "Gudfood Order List"
{
    Caption = 'Gudfood Order List';
    Editable = false;
    PageType = List;
    CardPageId = "Gudfood Order";
    SourceTable = "Gudfood Order Header";
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(No; Rec.No)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No field.';
                }
                field("Sell- to Customer No."; Rec."Sell- to Customer No.")
                {
                    TableRelation = Customer;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Sell- to Customer No. field.';
                }
                field("Sell- to Customer Name"; Rec."Sell- to Customer Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Sell- to Customer Name field.';
                }
                field("Order Date"; Rec."Order Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Order Date field.';
                }
                field("Posting No."; Rec."Posting No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Posting No. field.';
                    Editable = false;
                }
                field("Date Created"; Rec."Date Created")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Date Created field.';
                }
                field("Total Qty"; Rec."Total Qty")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Total Qty field.';
                }
                field("Total Amount"; Rec."Total Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Total Amount field.';
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 1 Code field.';
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 2 Code field.';
                }
                field("Dimension Set ID"; Rec."Dimension Set ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Dimension Set ID field.';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Export Headers")
            {
                Image = Export;
                trigger OnAction()
                begin
                    CurrPage.SETSELECTIONFILTER(GudfoodOrderHeader);
                    XMLPORT.RUN(50050, FALSE, FALSE, GudfoodOrderHeader);
                end;
            }
            action("Dimensions")
            {
                Image = Dimensions;
                trigger OnAction()
                begin
                    Rec.ShowDocDim();
                end;
            }
        }
    }
    var
        GudfoodOrderHeader: Record "Gudfood Order Header";

}
