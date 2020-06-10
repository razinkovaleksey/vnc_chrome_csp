# selenoid/vnc:chrome контейнер + КриптоПро CSP 5.0  + HDIMAGE Store + IFCPlugin (плагин для работ с порталом государственных услуг) Для входа с помощью электронной подписи через ЕСИА на портал Госуслуг на Linux.

![Alt text](choose_cert.jpg?raw=true "Выбор сертификата")

### Сборка 
Загрузить контейнеры с названиями вида 0e93ae32.000 и 6 файлами названиями *.key внутри в директорию cert

Если необходимо для контейнеров удалить пароль (чтобы не повялось каждый раз окно КриптоПро CSP) то для каждого контейнера добавить аргументы, например:

--build-arg CONTAINER_1=a2878a6c-c9cb-4876-baf4-c04b8a1d91b8 --build-arg PASSWORD_1=1234567890 --build-arg CONTAINER_2=80ce8100-08d3-45d7-922b-feab17573c0f --build-arg PASSWORD_2=1234567890 

где 

CONTAINER_1 - это имя первого контейнера для которго необходимо удалить пароль (Можно посмотреть в КриптоПро CSP - Серис - Просмотреть сертификаты в контейнере)

PASSWORD_1 - пароль первого контейнера (по умолчанию 1234567890)

CONTAINER_2 - имя второго контейнера

PASSWORD_2 - пароль второго контейнера

и тд

Аргументы Dockerfile (Необязательные)

CSP_LICENSE_KEY - Ключ активации КриптоПро CSP 5.0 

USER_NAME=selenium - Имя пользователя от которого будет производиться запуск драйвера (Default: selenium)


Build:
                
    docker build -t vnc_chrome_csp --build-arg CONTAINER_1=a2878a6c-c9cb-4876-baf4-c04b8a1d91b8 --build-arg CONTAINER_2=80ce8100-08d3-45d7-922b-feab17573c0f .

В составе Selenoid:
1. Добавить в ~/.aerokube/selenoid/browsers.json новый контейнер для Chrome или заменить selenoid/vnc_chrome:83.0 на vnc_chrome_csp:latest

    
2. Перезапустить selenoid
    ```
    docker kill -s HUP selenoid
    ```

Standalone:
   
1. docker run vnc_chrome_csp

Документацию по развертыванию Selenoid см. на https://github.com/aerokube/selenoid/

### Поддержка браузеров
Контейнер протестирован на Google Chrome 83.0. 
Для создения контейнера на основе другого браузера необходимо изменить первую строку в Dockerfile **"FROM selenoid/vnc:chrome_83.0"** выбрав из
имеющихся в открытом доступе (https://github.com/aerokube/selenoid/blob/master/docs/browser-image-information.adoc)

см также https://support.cryptopro.ru/index.php?/Knowledgebase/Article/View/275

см также https://forum.ubuntu.ru/index.php?topic=300549.0
