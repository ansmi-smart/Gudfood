page 50020 "Gudfood Order"
{
    Caption = 'Gudfood Order';
    PageType = Document;
    SourceTable = "Gudfood Order Header";

    layout
    {
        area(content)
        {
            group(General)
            {
                CaptionML = RUS = 'Общее';
                field(No; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No field.';
                }
                field("Sell- to Customer No."; Rec."Sell- to Customer No.")
                {
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
                }
                field("Date Created"; Rec."Date Created")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Date Created field.';
                    Editable = false;
                }
                field("Total Qty"; Rec."Total Qty")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Total Qty field.';
                    Editable = false;
                }
                field("Total Amount"; Rec."Total Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Total Amount field.';
                }
            }
            group(Dimension)
            {
                CaptionML = RUS = 'Измерения';
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

            part(OrderLines; "Gudfood Order Subpage")
            {
                ApplicationArea = All;
                SubPageLink = "Order No." = FIELD("No.");
            }

        }
    }

    actions
    {
        area(Processing)
        {
            action("Post")
            {
                Image = Post;
                Caption = 'Post order';
                trigger OnAction()
                begin
                    GudfoodOrderPost.PostOrder(Rec);
                end;
            }
            action("Print")
            {
                Image = Print;
                Caption = 'Print report';
                trigger OnAction()
                begin
                    REPORT.PRINT(50022, REPORT.RUNREQUESTPAGE(50022));
                end;
            }
            action("Export Order")
            {
                Image = Export;
                Caption = 'Export Order';
                trigger OnAction()
                begin
                    CurrPage.SETSELECTIONFILTER(GudfoodOrderHeader);
                    XMLPORT.RUN(50050, FALSE, FALSE, GudfoodOrderHeader);
                end;
            }
            action(Dimensions)
            {
                Image = Dimensions;
                Caption = 'Dimensions';
                trigger OnAction()
                begin
                    Rec.ShowDocDim;
                    CurrPage.SAVERECORD;
                end;
            }
        }
    }
    var
        GudfoodOrderHeader: Record "Gudfood Order Header";
        GudfoodOrderPost: Codeunit GudfoodOrderPost;
        DiscountConfirmation: Label 'You ordered lots of items. Do you want to get a 20% discount?';
}
