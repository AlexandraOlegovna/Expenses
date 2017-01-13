module Handler.ShowExpenses where

import Import

getShowExpensesR :: Handler ()
getShowExpensesR = sendFile "text/html" "static/main.html"



postShowExpensesR :: Handler ()
postShowExpensesR = undefined
