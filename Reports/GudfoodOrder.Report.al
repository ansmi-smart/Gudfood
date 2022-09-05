report 50021 "Gudfood Order"
{
    Caption = 'Gudfood Order';
    DefaultLayout = RDLC;
    RDLCLayout = 'Report.rdl';

    dataset
    {
        dataitem(GudfoodOrderHeader; "Gudfood Order Header")
        {
            column(OrderDate; "Order Date")
            {

            }
            column(SelltoCustomerNo; "Sell- to Customer No.")
            {
            }
            column(SelltoCustomerName; "Sell- to Customer Name")
            {
            }
            column(PrinterPerson; PrinterPerson)
            {

            }
            dataitem(GudfoodOrderLine; "Gudfood Order Line")
            {
                column(ItemNo; "Item No.")
                {

                }
                column(ItemType; "Item Type")
                {

                }
                column(Description; Description)
                {

                }
                column(Quantity; Quantity)
                {

                }
                column(UnitPrice; "Unit Price")
                {

                }
                column(Amount; Amount)
                {

                }
                trigger OnPreDataItem()
                begin
                    GudfoodOrderLine.SetRange("Sell- to Customer No.", GudfoodOrderHeader."Sell- to Customer No.");
                end;
            }
        }
    }
    var
        PrinterPerson: Text;

    trigger OnPreReport()
    begin
        PrinterPerson := Database.UserId;
    end;
}
