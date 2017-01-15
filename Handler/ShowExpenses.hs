module Handler.ShowExpenses where

import Import

getShowExpensesR :: Handler ()
getShowExpensesR = sendFile "text/html" "static/tablo.html"



postShowExpensesR :: Handler ()
postShowExpensesR = undefined
