# Project 2 - Flix Finder

Flix Finder is a movies app using the [The Movie Database API](http://docs.themoviedb.apiary.io/#).

Time spent: 12-13 hours spent in total

## User Stories

The following **required** functionality is complete:

- [x] User can view a list of movies currently playing in theaters from The Movie Database.
- [x] Poster images are loaded using the UIImageView category in the AFNetworking library.
- [x] User sees a loading state while waiting for the movies API.
- [x] User can pull to refresh the movie list.

The following **optional** features are implemented:

- [x] User sees an error message when there's a networking error.
- [x] Movies are displayed using a CollectionView instead of a TableView.
- [x] User can search for a movie.
- [x] All images fade in as they are loading.
- [x] User can view the large movie poster by tapping on a cell. (BY TAPPING ON POSTER ON DETAILS PAGE)
- [x] For the large poster, load the low resolution image first and then switch to the high resolution image when complete.
- [x] Customize the selection effect of the cell.
- [x] Customize the navigation bar.
- [x] Customize the UI.

The following **additional** features are implemented:

- [x] User can see release date and average rating on details page.
- [x] User sees placeholder images while waiting for movie images to load.
- [x] In the detail view, when the user taps the projector icon, the user can view the trailer.
- [x] In the detail view, when the user taps the popcorn icon, the user can view similar movies.

Please list two areas of the assignment you'd like to **discuss further with your peers** during the next class (examples include better ways to implement something, how to extend your app in certain ways, etc):

1. How to use the database to create you own watchlist. (Saving list data)
2. How to design a good UI.

## Video Walkthrough

Here's a walkthrough of implemented user stories:

<img src='https://i.imgur.com/a/A9oyQQp.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />
GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Notes

Implementing the activity indicator and getting the refresh to stop after answering the alert prompt were tricky. It ended up being minor things that I kept overlooking that was causing the issue. For example, my activity indicator was hiding behind my view and I had an extra line of code that was breaking my alert prompt and refresh compatibility.

## Credits

List an 3rd party libraries, icons, graphics, or other assets you used in your app.


Poster Placeholder Image: http://www.theprintworks.com/film/raazi/

Backdrop Placeholder Image: https://www.omao.noaa.gov/find/media/video/noaa-ships-oscar-elton-sette-and-rainier-dry-docking

Popcorn Icon: https://www.pinterest.com/pin/515169644870731509/

Projector Icon: https://www.kisspng.com/png-movie-projector-film-computer-icons-projector-982018/



- [AFNetworking](https://github.com/AFNetworking/AFNetworking) - networking task library

This product uses the TMDb API but is not endorsed or certified by TMDb.

## License

    Copyright 2018 Riley Schnee

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
