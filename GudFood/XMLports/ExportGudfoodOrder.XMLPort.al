xmlport 50050 "Export Gudfood Order"
{
    Caption = 'Export Gudfood Order';
    Direction = Export;
    UseRequestPage = false;
    schema
    {
        textelement(RootNodeName)
        {
            tableelement(GudfoodOrderHeader; "Gudfood Order Header")
            {
                RequestFilterFields = "No.";
                fieldelement(No; GudfoodOrderHeader."No.")
                {
                }
                fieldelement(SelltoCustomerNo; GudfoodOrderHeader."Sell- to Customer No.")
                {
                }
                fieldelement(SelltoCustomerName; GudfoodOrderHeader."Sell- to Customer Name")
                {
                }
                fieldelement(OrderDate; GudfoodOrderHeader."Order Date")
                {
                }
                fieldelement(PostingNo; GudfoodOrderHeader."Posting No.")
                {
                }
                fieldelement(DateCreated; GudfoodOrderHeader."Date Created")
                {
                }
                fieldelement(TotalQty; GudfoodOrderHeader."Total Qty")
                {
                }
                fieldelement(TotalAmount; GudfoodOrderHeader."Total Amount")
                {
                }
                tableelement(GudfoodOrderLine; "Gudfood Order Line")
                {
                    LinkTable = GudfoodOrderHeader;
                    LinkFields = "Order No." = FIELD("No.");
                    fieldelement(OrderNo; GudfoodOrderLine."Order No.")
                    {
                    }
                    fieldelement(LineNo; GudfoodOrderLine."Line No.")
                    {
                    }
                    fieldelement(SellToCustomerNo; GudfoodOrderLine."Sell- to Customer No.")
                    {
                    }
                    fieldelement(DateCreated; GudfoodOrderLine."Date Created")
                    {
                    }
                    fieldelement(ItemNo; GudfoodOrderLine."Item No.")
                    {
                    }
                    fieldelement(ItemType; GudfoodOrderLine."Item Type")
                    {
                    }
                    fieldelement(Description; GudfoodOrderLine.Description)
                    {
                    }
                    fieldelement(Quantity; GudfoodOrderLine.Quantity)
                    {
                    }
                    fieldelement(UnitPrice; GudfoodOrderLine."Unit Price")
                    {
                    }
                    fieldelement(Amount; GudfoodOrderLine.Amount)
                    {
                    }
                }
                trigger OnPreXmlItem()
                begin
                    IF GudfoodOrderLine."Order No." <> GudfoodOrderHeader."No." THEN
                        currXMLport.SKIP;
                end;
            }
        }
    }
    trigger OnInitXmlPort()
    begin
        IF GudfoodOrderLine."Order No." <> GudfoodOrderHeader."No." THEN
            currXMLport.SKIP;
    end;
}
