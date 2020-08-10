Original App Design Project 
===

# Music Sharing App

## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Wireframes](#Wireframes)
2. [Schema](#Schema)

## Overview
### Description
A social media to share music and be able to find and share new songs with anyone. Post your favorite song, add a picture describing the vibe of the song and get reccomendations based on you last posts. You are able to search for new music that people share and here the songs directly from the post. (App is connected to Spotify.)

### App Evaluation

- **Category:** Social/Music Streaming

- **Mobile:** Mobile first experience, uses camera to add picture to post. At first feed will be designed for mobile devices. To be able to hear songs, the user needs to have a mobile device with Spotify (Premium) intalled. 

- **Story:** Allows users to share new sounds with friends, also share pictures and thoughts on how songs make them feel. 

- **Market:** Anyone who is willing to share their music selection and appreciate the value of one good song with others.

- **Habit:** User will be able to access the app and post / share at any time. Also search for something new to hear based on shared songs or in the recommended view and listen to the songs.

- **Scope:** This app will aloud you to share music from Spotify . You have the option to add a picture in the post. The post will have an structure but there will be room for comments. It is a navigable app so it is easier to search for new songs and filter the search based on the field that you want. If you have Spotify Premium you will be able to listen to the songs directly from the app. Aside from finding new sounds based on what people are posting, you can find new sounds that are exclusively recommended for you based on your posts. 

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**
 
* user can login
* user can sign up with a new account
* user can view a feed of posts
* user can create a post on feed
    * structured post
* user can add an optional picture to the post
* user can like posts
* user can tap on post and view details
* user can search for posts (e.g. songs, genre, mood...)

**Optional Nice-to-have Stories**
* user can comment/reply to other user's post
* user view comments on post in the details screen
* user can see their profile
* use Spotify API to play songs
* user can search for other users
* user can follow/unfollow other users(future feature)



### 2. Screen Archetypes

* Login Screen
   * user can login
* Register Screen
   * user can sign up with a new account
* Stream
    * user can view a feed of posts
    * user can like posts
* Details
    * user can tap on post and view details 
* Creation 
    * user can create a post on feed
    * user can add an optional picture to the post
* Search
    * user can search for other users
    * user can search for posts (e.g. songs, mood, genre...)

### 3. Navigation

**Tab Navigation** (Tab to Screen)

* Stream
* Creation
* Search 
* Profile
* Recommended

**Flow Navigation** (Screen to Screen)

* Login Screen
   => Stream
* Register Screen
   => Stream
* Stream
   => Details Screen.
* Creation 
   => Stream (after post is finished)
* Search
    => Details of searched user or post (if completed).
* Profile
    => Details
    => Edit Profile
* Recommended
    => Creation

## Wireframes
[Add picture of your hand sketched wireframes in this section]
<img src="https://github.com/fabiolarobles1/OriginalApp-MusicSharing/blob/master/20200707_132242.jpg?raw=true" width=800>


## Schema 
### Models
#### Post

   | Property      | Type     | Description |
   | ------------- | -------- | ------------|
   | objectId      | String   | unique id for the user post (default field) |
   | createdAt     | DateTime | date when post is created (default field) |
   | updatedAt     | DateTime | date when post is last updated (default field) |
   | author        | Pointer to User     | post's author |
   | musicLink     | String   | URL string of song or playlist which the post is about |
   | caption       | String   | song/playlist's caption by author |
   | image         | File     | post's song descriptive image (optional)|
   | likesCount    | Number   | number of likes for the post |
   | commentsCount | Number   | number of comments for the post |
   | genre         | String   | post's song genre|
   | mood          | String   | small description of how the song makes the author feel|
   
#### User

   | Property      | Type     | Description |
   | ------------- | -------- | ------------|
   | objectId      | String   | unique id for the user post (default field) |
   | createdAt     | DateTime | date when post is created (default field) |
   | updatedAt     | DateTime | date when post is last updated (default field) |
   | username      | String   | user's screenname |
   | posts         | Arrays   | Array of all the user's posts |
   | password      | String   |user's login password |
   
   
### Networking
#### List of network requests by screen
   - Home Feed Screen
      - (Read/GET) Query posts for user's feed
      - (Create/POST) Create a new like on a post
      - (Delete) Delete existing like
   - Create Post Screen
      - (Create/POST) Create a new post object
   - Details Screen
      - (Read/GET) Get post details and comments
      - (Create/POST) Create a new like on a post
      - (Delete) Delete existing like
      - (Create/POST) Create a new comment on a post
      - (Delete) Delete existing comment
   - Search Screen
      - (Read/GET) Query posts that meet search constrains
