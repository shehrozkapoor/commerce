from django.urls import path

from . import views

urlpatterns = [
    path("", views.index, name="index"),
    path("login", views.login_view, name="login"),
    path("logout", views.logout_view, name="logout"),
    path("register", views.register, name="register"),
    path("create_listing",views.create_listing,name="create_listing"),
    path("clicked_auction/<int:auction>",views.clicked_auction,name="clicked_auction"),
    path("adding_comments/<int:auction_a>",views.comment,name="comment"),
    path("catagories/<str:cata>",views.catagory,name="catagory"),
    path("watchlist/<str:item_id>",views.watch_list,name="watchlist"),
    path("addwatchlist/<int:item_add>",views.add_watchlist,name="addwatchlist"),
    path("removewatchlist/<int:item_remove>",views.remove_watchlist,name="removewatchlist"),
    path("closedauction/<int:close_item>",views.closed_auctions,name="closedauctions"),
    path("closed_auctions_list",views.show_closed,name="show_clossed")

]
