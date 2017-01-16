{-# LANGUAGE FlexibleContexts #-}
module Handler.PostNew where


import Import
import           Data.Aeson
import qualified Data.ByteString.Lazy.Char8 as L
import           Data.Text
import Prelude
import Database.Persist.Sql


postPostNewR :: Handler Value
postPostNewR = do
    (Just login) <- lookupCookie "login"
    Just (Entity user_id _) <- runDB $ getBy $ UniqueUser login
    expenses <- runDB $ selectList [ExpensesUserId ==. user_id] []
    returnJson expenses
