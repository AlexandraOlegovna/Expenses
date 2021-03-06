{-# LANGUAGE OverloadedStrings #-}
module Handler.Home where

import Import
-- import Text.Hamlet (shamlet)
-- import Text.Blaze.Html.Renderer.String (renderHtml)
import Data.Text
import Data.Maybe
import Yesod.Form.Bootstrap3 (BootstrapFormLayout (..), renderBootstrap3)
import Text.Julius (RawJS (..))
import Text.Hamlet (HtmlUrl, hamlet)
import Database.Persist
import Database.Persist.Sqlite
import Database.Persist.TH
import qualified Data.ByteString.Char8 as S8
import qualified Data.Text as T
import Web.Cookie
import Prelude


-- This is a handler function for the GET request method on the HomeR
-- resource pattern. All of your resource patterns are defined in
-- config/routes
--
-- The majority of the code you will write in Yesod lives in these handler
-- functions. You can spread them across multiple files if you are so
-- inclined, or create a single monolithic file.

-- getHomeR :: Handler Html
getHomeR :: Handler ()
getHomeR = sendFile "text/html" "static/index.html"
-- getHomeR = do
--     (formWidget, formEnctype) <- generateFormPost sampleForm
--
--     let submission = Nothing :: Maybe FileForm
--         handlerName = "getHomeR" :: Text
--
--     defaultLayout $ do
--         let (commentFormId, commentTextareaId, commentListId) = commentIds
--         aDomId <- newIdent
--         setTitle "Welcome To Yesod!"
--         $(widgetFile "homepage")

postRegisterR :: Handler Text
postRegisterR = do
    (Just login) <- lookupPostParam "login"
    (Just password) <- lookupPostParam "password"
    maybeUser <- runDB $ getBy $ UniqueUser login
    case maybeUser of
        Nothing -> do
            runDB $ insert $ User login password
            setCookie $ def { setCookieName = "login", setCookieValue = S8.pack $ T.unpack $ login }
            return "OK"
        _ -> return "Error"

postSignInR :: Handler Text
postSignInR = do
    (Just login) <- lookupPostParam "login"
    (Just password) <- lookupPostParam "password"
    maybeUser <- runDB $ getBy $ UniqueUser login
    case maybeUser of
        Nothing ->
            return "Error"
        Just (Entity _ users) ->
            if (userPassword users) == password then do
                setCookie $ def { setCookieName = "login", setCookieValue = S8.pack $ T.unpack $ login }
                return "OK"
            else
                return "Error"

postInsertNewR :: Handler Value
postInsertNewR = do
    (Just op) <- lookupPostParam "op"
    (Just theme) <- lookupPostParam "theme"
    (Just item) <- lookupPostParam "item"
    (Just cost) <- lookupPostParam "cost"
    (Just date) <- lookupPostParam "date"
    (Just login) <- lookupCookie "login"
    Just (Entity id_user _) <- runDB $ getBy $ UniqueUser login
    id_exp <- runDB $ insert $ Expenses id_user op theme item ((read $ Import.unpack cost) :: Int) date
    returnJson id_exp


-- postDeleteRecR :: Handler Text
-- postDeleteRecR = do
--     (Just op) <- lookupPostParam "op"
--     (Just theme) <- lookupPostParam "theme"
--     (Just item) <- lookupPostParam "item"
--     (Just cost) <- lookupPostParam "cost"
--     (Just date) <- lookupPostParam "date"
--     (Just login) <- lookupCookie "login"
--     Just (Entity id_user _) <- runDB $ getBy $ UniqueUser login
--     id_exp <- runDB $ selectFirst [ExpensesUserId ==. id_user, ExpensesOlolo ==. op, ExpensesTheme ==. theme, ExpensesItem ==. item, ExpensesCost ==. (read $ show cost), ExpensesDate ==. date]
--     runDB $ delete id_exp
--     return "OK"

postDeleteRecR :: Handler Text
postDeleteRecR = do
    (Just id_exp) <- lookupPostParam "id"
    runDB $ delete $ (toSqlKey (read $ Import.unpack id_exp) :: ExpensesId)
    return "OK"

-- postDeleteRecR :: Handler Value
-- postDeleteRecR = do
--     (Just id_exp) <- lookupPostParam "id"
--     -- runDB $ delete $ (toSqlKey (read $ show id_exp) :: ExpensesId)
--     -- runDB $ delete $ ((toSqlKey ((read $ show id_exp) :: Int64)) :: ExpensesId)
--     returnJson $ (read :: (String -> Int64)) $ show id_exp


postHomeR :: Handler Html
postHomeR = Import.undefined
    -- lp <- requireJsonBody :: Handler LogPass -- get the json body as Foo (assumes FromJSON instance)
    -- getParameters <- reqGetParams <$> getRequest
    -- (Just lgValueMaybe) <- lookupPostParam "login"
    -- (Just pasValueMaybe) <- lookupPostParam "password"
    -- userId <- runDB $ insert $ User (lgValueMaybe) (Just pasValueMaybe)
    -- users <- runDB $ selectList [] []
    -- maybeUser <- runDB $ getBy $ UniqueUser "aaaaaaa"
    -- case maybeUser of
    --     Nothing -> defaultLayout [whamlet|<p>No|]
    --     _ -> defaultLayout [whamlet|<p>Yes|]
    -- defaultLayout $
    --     [whamlet|
    --             $forall Entity userId user <- users
    --                 <h1> #{userIdent user} by #{show (userPassword user)}
    --     |]
    -- userId <- runDB $ insert $ User (lgValueMaybe) (Just pasValueMaybe)
    -- maybeUser <- runDB $ get userId
    -- case maybeUser of
        -- Nothing -> defaultLayout [whamlet|<p>No|]
        -- _ -> defaultLayout [whamlet|<p>Yes|]

    -- ((result, formWidget), formEnctype) <- runFormPost sampleForm
    -- let handlerName = "postHomeR" :: Text
    --     submission = case result of
    --         FormSuccess res -> Just res
    --         _ -> Nothing
    --
    -- defaultLayout $ do
    --     let (commentFormId, commentTextareaId, commentListId) = commentIds
    --     aDomId <- newIdent
    --     setTitle "Welcome To Yesod!"
    --     $(widgetFile "homepage")
--
-- sampleForm :: Form FileForm
-- sampleForm = renderBootstrap3 BootstrapBasicForm $ FileForm
--     <$> fileAFormReq "Choose a file"
--     <*> areq textField textSettings Nothing
--     -- Add attributes like the placeholder and CSS classes.
--     where textSettings = FieldSettings
--             { fsLabel = "What's on the file?"
--             , fsTooltip = Nothing
--             , fsId = Nothing
--             , fsName = Nothing
--             , fsAttrs =
--                 [ ("class", "form-control")
--                 , ("placeholder", "File description")
--                 ]
--             }
--
-- commentIds :: (Text, Text, Text)
-- commentIds = ("js-commentForm", "js-createCommentTextarea", "js-commentList")
