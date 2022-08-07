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

<a name="teck-stack"/>

## Tech Stack
* Swift 5.6
* KingFisher Library
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
<img width="991" alt="스크린샷 2022-08-07 오후 10 01 44" src="https://user-images.githubusercontent.com/107173548/183291956-4c025f44-4f4c-477a-aecd-d0eea1ff074b.png">

