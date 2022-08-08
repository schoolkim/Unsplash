<p align="center"><img width="878" alt="스크린샷 2022-08-07 오후 8 51 52" src="https://user-images.githubusercontent.com/107173548/183289288-a3083eb6-c340-46fd-b3d7-80f3ed5c935c.png"></p>

# Unsplashrimp
Unsplashrimp는 unsplash api를 기반으로 한 clone 어플리케이션입니다.</br>
토픽별로 사진 리스트를 확인할 수 있으며 탭하여 하나하나 확인 가능합니다.</br>
또한 사진의 제목을 검색할 수 있는 검색 기능을 구현하였습니다.

</br>
</br>
</br>

# Table of contents
* [Tech Stack](#tech-stack)
* [Basic Concept](#basic-concept)
* [Application Architecture](#architecture)
* [Simulation](#simulation)
</br>
</br>
</br>

<a name="teck-stack"/>

## Tech Stack
* Swift 5.6
* KingFisher Library
</br>
</br>
</br>

<a name="basic-concept"/>

## Basic Concept
<p align="center"><img width="1178" alt="스크린샷 2022-07-27 오후 7 06 14" src="https://user-images.githubusercontent.com/107173548/181224182-d903bc75-48db-49ea-a377-92358b90c1eb.png"></p>
</br>
기본적으로 MVC 패턴을 활용하여 View로부터 UserAction이 발생하면 Controller의 동작을 통해 Model을 </br> 
Update되고 Model의 Update가 완료되면 Controller를 통해 다시 Update된 사항이 View를 통해 사용자에게 보여지게 됩니다.
</br>
</br>
</br>

<a name="architecture"/>

## Application architecture
<p align="center"><img width="991" height="600" alt="스크린샷 2022-08-07 오후 10 01 44" src="https://user-images.githubusercontent.com/107173548/183291956-4c025f44-4f4c-477a-aecd-d0eea1ff074b.png"></p>
</br>
기본적인 application architecture로 MVC 패턴을 기반으로 구성하였습니다.
</br>
</br>
</br>

<a name="simulation"/>

## Simulation
### 1. Scrolling photo list
</br>
<p>
<img src="https://user-images.githubusercontent.com/107173548/183364935-125791f0-2284-4a66-9eef-28424b80143c.gif" height=400 width=250>
</p>
photo list를 아래로 스크롤하여 다양한 사진들을 볼 수 있습니다.
</br>

### 2. Tap photo
</br>
<p>
<img src="https://user-images.githubusercontent.com/107173548/183368743-ce2fcf45-64de-4cd9-baae-c655eb8967ce.gif" height=400 width=250>
</p>
원하는 사진을 탭하면 확대해서 볼 수 있으며 좌우로 스크롤하여 다음 사진으로 넘어갈 수 있습니다.
</br>

### 3. Tap another topic
</br>
<p>
<img src="https://user-images.githubusercontent.com/107173548/183370035-31992686-28cf-4ae6-8156-4c89c2f6b9c3.gif" height=400 width=250>
</p>
원하는 토픽을 탭하며 다른 photo list를 확인할 수 있습니다.
</br>

### 4. Search photos
</br>
<p>
<img src="https://user-images.githubusercontent.com/107173548/183389998-97fcbde1-94ef-4165-99f6-2062e89ec315.gif" height=400 width=250>
</p>
검색 기능을 사용하여 원하는 사진을 검색할 수 있습니다.
</br>
