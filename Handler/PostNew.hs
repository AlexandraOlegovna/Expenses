module Handler.PostNew where


import Import
import           Data.Aeson
import qualified Data.ByteString.Lazy.Char8 as L
import           Data.Text

postPostNewR :: Handler Value
postPostNewR = do
    (Just login) <- lookupCookie "login"
    Just (Entity user_id _) <- runDB $ getBy $ UniqueUser login
    expenses <- runDB $ selectList [ExpensesUserId ==. user_id] []
    -- (Entity _ _data) <- expenses
    -- exp_ <- map (\(Entity _ data_) -> data_) expenses
    -- return exp_
    returnJson expenses
    -- return "OK"
