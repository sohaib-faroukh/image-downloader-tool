# Image Downloader Tool

A tool to download image files from URLs that are provided in a text input file

# Prerequisite
- Ruby version 3.0.x

# Installation
- Using git, please run `git clone https://github.com/sohaib-faroukh/image-downloader-tool.git`
- Then please run `cd image-downloader-tool`
- Then to install the dependencies, please run
`bundle install`
- Make sure you set all the required environment variables, an example of the variables is the following:

```
DEFAULT_IMAGES_LOCAL_STORAGE_PATH=storage
LOGS_PREFIX='#IMAGE_DOWNLOAD_TOOL'
MAX_ALLOWED_IMAGE_SIZE=20971520
MAX_CONCURRENT_THREADS=5
IMAGE_URLS_DELIMETER_REGEX='[,;\s]+'
```
### Environment variables description
Env variable name  | Description | Value type | Example
------------------ | ----------- | ---------- | -----------
DEFAULT_IMAGES_LOCAL_STORAGE_PATH | The relative path of the directory where you need to store the images in the file system | string | `storage-folder`
LOGS_PREFIX | A prefix to add to your stream logs | string | `'#IMAGE_DOWNLOAD_TOOL'`
MAX_CONCURRENT_THREADS | Max allowed concurrent number of threads | Integer | `3`
MAX_ALLOWED_IMAGE_SIZE | Max allowed image size by Byte | Integer | `20971520`
IMAGE_URLS_DELIMETER_REGEX | A regular expression string to determine which charecters are going to be used to split the image URLs in the input file, by default it will be any whitespace char or `,` or `;` | Valid Regex String | `'[,;\s]+'`


>*Note: To run locally, simply you can create `.env` file and place all the environment variable with their values in it*

# How to use

- After installing the dependencies and setting up the environment variables you can use the following command `rake download_images <input text file path>`
> *As an example  `rake download_images images_urls_file.txt` while `images_urls_file.txt` content is something like this:*
```
https://images.pexels.com/photos/17715610/pexels-photo-17715610/free-photo-of-art-building-architecture-historical.jpeg
https://images.pexels.com/photos/14894269/pexels-photo-14894269.jpeg
https://images.pexels.com/photos/16646219/pexels-photo-16646219/free-photo-of-view-of-traditional-residential-buildings-and-hotels-in-paris-france.jpeg
https://images.pexels.com/photos/16106259/pexels-photo-16106259/free-photo-of-photo-of-a-glacier.jpeg
https://images.pexels.com/photos/17715610/pexels-photo-17715610/free-photo-of-art-building-architecture-historical.jpeg
https://images.pexels.com/photos/14894269/pexels-photo-14894269.jpeg

```
