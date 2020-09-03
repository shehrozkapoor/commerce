from django.contrib.auth import authenticate, login, logout
from django.db import IntegrityError
from django.http import HttpResponse, HttpResponseRedirect
from django.shortcuts import render
from django.urls import reverse
from .models import *

def index(request):
    bids = Bids.objects.all()
    return render(request, "auctions/index.html",{
        "auctions":bids
    })


def login_view(request):
    if request.method == "POST":

        # Attempt to sign user in
        username = request.POST["username"]
        password = request.POST["password"]
        user = authenticate(request, username=username, password=password)

        # Check if authentication successful
        if user is not None:
            login(request, user)
            return HttpResponseRedirect(reverse("index"))
        else:
            return render(request, "auctions/login.html", {
                "message": "Invalid username and/or password."
            })
    else:
        return render(request, "auctions/login.html")


def logout_view(request):
    logout(request)
    return HttpResponseRedirect(reverse("index"))


def register(request):
    if request.method == "POST":
        username = request.POST["username"]
        email = request.POST["email"]

        # Ensure password matches confirmation
        password = request.POST["password"]
        confirmation = request.POST["confirmation"]
        if password != confirmation:
            return render(request, "auctions/register.html", {
                "message": "Passwords must match."
            })

        # Attempt to create new user
        try:
            user = User.objects.create_user(username, email, password)
            user.save()
        except IntegrityError:
            return render(request, "auctions/register.html", {
                "message": "Username already taken."
            })
        login(request, user)
        return HttpResponseRedirect(reverse("index"))
    else:
        return render(request, "auctions/register.html")

def create_listing(request):
    if request.method=="POST":
        title = request.POST["title"]
        description = request.POST["description"]
        bid = request.POST["bid"]
        url_img = request.POST["url"]
        auction_c= request.POST["a_catagory"]
        current_user = request.user
        auction = Auctions(title=title,description=description,url=url_img,owner=current_user,Catagory=auction_c)
        auction.save()
        bid = Bids(item_id=auction,user=current_user,bid=bid)
        bid.save()
        return render(request, 'auctions/index.html',{"auctions":Bids.objects.all()})
    return render(request, "auctions/create_listing.html",{"message":"nothing to render","catagories":Catagories.objects.all()})

def clicked_auction(request,auction):
    # getting related comments from database
    rel_comment = []
    comment = comments.objects.all()
    for c in comment:
        if c.auction.id == auction:
            rel_comment.append(c)
    # getting data from form if method is request than if will work and get all the values from form and then save into the database
    if request.method=="POST":
        get_bid  = float(request.POST["bid"])
        bid = Bids.objects.all()
        for a in bid:
            if a.item_id.id == auction:
                bid = a
        if get_bid <= bid.bid:
            return render(request, "auctions/clicked_auction.html",{"item":bid,"message":"Place Higher Bid than Before","comments":rel_comment})
        bid.bid = get_bid
        bid.user = request.user
        bid.save()
        return render(request, "auctions/clicked_auction.html",{"item":bid,"comments":rel_comment})
    # if method is not post then it will get all the data from database and display to the user
    a_auction = Bids.objects.all()
    for a in a_auction:
        if a.item_id.id == auction:
            a_auction = a
    return render(request, "auctions/clicked_auction.html",{"item":a_auction,"comments":rel_comment})

def comment(request,auction_a):
    get_comment = request.POST["comment"]
    auction = Auctions.objects.get(pk=auction_a)
    c = comments(comment=get_comment,auction=auction)
    c.save()
    bid = Bids.objects.all()
    for a in bid:
        if a.item_id.id == auction_a:
            bid = a
    rel_comment = []
    comment = comments.objects.all()
    for c in comment:
        if c.auction.id == auction_a:
            rel_comment.append(c)
    return render(request, "auctions/clicked_auction.html",{"item":bid,"comments":rel_comment})
def watch_list(request,item_id):
    Watch_list = []
    w = WatchList.objects.all()
    for i in w:
        if i.user.username == item_id:
            Watch_list.append(i)
    return render(request, "auctions/watchlist.html",{"items":Watch_list})
def add_watchlist(request,item_add):
    b = Bids.objects.all()
    for i in b:
        if i.item_id.id == item_add:
            b = i 
    w = WatchList(user=request.user,item_id=b)
    w.save()
    return HttpResponseRedirect(reverse(watch_list,args=(request.user.username,)))
def remove_watchlist(request,item_remove):
    w = WatchList.objects.all()
    for i in w:
        if i.item_id.item_id.id == item_remove:
            w = i
    w.delete()
    return HttpResponseRedirect(reverse(watch_list,args=(request.user.username,)))
def catagory(request,cata):
    if request.method == "POST":
        auctions = []
        bid = Bids.objects.all()
        for i in bid:
            if i.item_id.Catagory==cata:
                auctions.append(i)
        return render(request, "auctions/index.html" ,{"auctions":auctions})
    geting_cata = Catagories.objects.all()
    return render(request, "auctions/catagory.html",{"catagories":geting_cata})
def closed_auctions(request,close_item):
    bid = Bids.objects.all()
    max_bid = 0
    username = ""
    for b in bid:
        if b.item_id.id == close_item:
            if b.bid>max_bid:
                username = b.user.username
                max_bid = b.bid
            bid = b
    auction = Auctions.objects.all()
    for a in auction:
        if a.id == close_item:
            auction = a
    close = Closed_auctions(auction=auction,username=username,bid = max_bid)
    close.save()
    bid.delete()
    return HttpResponseRedirect(reverse("index"))

def show_closed(request):
    return render(request, "auctions/closed_auctions.html",{"items":Closed_auctions.objects.all()})