from django.contrib import admin
from .models import *
# Register your models here.

admin.site.register(Auctions)
admin.site.register(User)
admin.site.register(comments)
admin.site.register(Bids)
admin.site.register(Catagories)
admin.site.register(WatchList)
admin.site.register(Closed_auctions)