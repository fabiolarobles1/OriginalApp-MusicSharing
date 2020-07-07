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
A social media to share music, meet people based on your music taste and be able to find and share new playlists with anyone. Post your favorite song or playlist, add a picture describing the vibe of the song/playlist. Be able to search for new music that people share.

### App Evaluation

- **Category:** Social/Music
- **Mobile:** Mobile first experience, uses camera to add picture to post. At first feed will be designed for mobile devices. 
- **Story:** Allows users to share music and new sounds with friends, also share playlists and thoughts on how songs make them feel. 

- **Market:** Anyone who is willing to share their music selection and appreciate the value of one good song with others.

- **Habit:** User will be able to access the app and post / share at any time. Also search for something new to hear based on shared playlists / songs.

- **Scope:** This app will aloud you to share music and playlists  from streaming plataforms such as Spotify or Apple Music. Also links to songs or music videos, etc.. You have the option to add a picture in the post. The post will have an structure but there will be room for comments. Eventually it would be a navigable app so it is easier to search for new songs.

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**
 
* user can login
* user can sing up with a new account
* user can view a feed of posts
* user can create a post on feed
    * structured post
* user can add an optional picture to the post
* user can like posts
* user can tap on post and view details
* user can search for other users
* user can follow/unfollow other users
* user can search for posts (e.g. songs, playlists)

**Optional Nice-to-have Stories**
* user can comment/reply to other user's post
* user view comments on post in the details screen
* user can see their profile
* use Spotify API to render playlist 



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
    * user can follow/unfollow other users
    * user can search for posts (e.g. songs, playlists)

### 3. Navigation

**Tab Navigation** (Tab to Screen)

* Stream
* Creation
* Search 

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
    

## Wireframes
[Add picture of your hand sketched wireframes in this section]
<img src="https://github.com/fabiolarobles1/OriginalApp-MusicSharing/blob/master/20200707_132242.jpg?raw=true" width=800>

### [BONUS] Digital Wireframes & Mockups

### [BONUS] Interactive Prototype

## Schema 
[This section will be completed in Unit 9]
### Models
[Add table of models]
### Networking
- [Add list of network requests by screen ]
- [Create basic snippets for each Parse network request]
- [OPTIONAL: List endpoints if using existing API such as Yelp]
