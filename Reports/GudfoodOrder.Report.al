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
            column(PrinterPerson; Database.UserId)
            {

            }
            dataitem(GudfoodOrderLine; "Gudfood Order Line")
            {
                DataItemLink = "Order No." = FIELD(No);

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
            }
        }
    }
}
