module Handler.ShowExpenses where

import Import

getShowExpensesR :: Handler ()
getShowExpensesR = sendFile "text/html" "static/table.html"



postShowExpensesR :: Handler ()
postShowExpensesR = undefined
