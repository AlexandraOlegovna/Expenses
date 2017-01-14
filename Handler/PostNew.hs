module Handler.PostNew where


import Import

postPostNewR :: Handler Text
postPostNewR = do
    (Just login) <- lookupPostParam "login"
    Just (Entity user_id _) <- runDB $ getBy $ UniqueUser login
    expenses <- runDB $ selectList [ExpensesUserId ==. user_id] []
    -- return $ toMessage expenses
    return "OK"
