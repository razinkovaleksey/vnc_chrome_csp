# selenoid/vnc:chrome контейнер + КриптоПро CSP 5.0  + HDIMAGE Store + IFCPlugin (плагин для работ с порталом государственных услуг) Для входа с помощью электронной подписи через ЕСИА на портал Госуслуг на Linux.

![Alt text](choose_cert.jpg?raw=true "Выбор сертификата")

### Сборка 
Создать директорию cert и загрузить контейнеры с названиями вида 0e93ae32.000 и 6 файлами названиями *.key внутри в директорию cert

Если необходимо для контейнеров удалить пароль (чтобы не повялось каждый раз окно КриптоПро CSP) то для каждого контейнера добавить аргументы, например:

--build-arg CONTAINER_1=492cafd5c-38c6-8604-1f4c-9af3b8bae40 --build-arg PASSWORD_1=1234567890 --build-arg CONTAINER_2=94582eb8a-724f-bfd1-75c0-4166db041ec --build-arg PASSWORD_2=1234567890 

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
                
    docker build -t vnc_chrome_csp --build-arg CONTAINER_1=492cafd5c-38c6-8604-1f4c-9af3b8bae40 --build-arg CONTAINER_2=94582eb8a-724f-bfd1-75c0-4166db041ec .

В составе Selenoid:
1. Добавить в ~/.aerokube/selenoid/browsers.json новый контейнер для Chrome или заменить selenoid/vnc_chrome:83.0 на vnc_chrome_csp:latest

    
2. Перезапустить selenoid
    ```
    docker kill -s HUP selenoid
    ```
    
3. Добавить crx в капабилити

    ```python
    import os
    from selenium import webdriver

    chrome_options = selenium.webdriver.chrome.options.Options()
    chrome_options.add_extension(os.path.join(os.getcwd(), 'plugin.crx'))
    desired_capabilities = chrome_options.to_capabilities()

    desired_capabilities['browserName'] = "chrome"
    desired_capabilities['version'] = "83.0"
    desired_capabilities['enableVNC'] = True
    desired_capabilities['enableVideo'] = False

    driver = webdriver.Remote(command_executor="http://selenoid:4444/wd/hub", desired_capabilities=desired_capabilities)
    ```

Standalone:
   
1. docker run vnc_chrome_csp

Документацию по развертыванию Selenoid см. на https://github.com/aerokube/selenoid/

### Поддержка браузеров
Контейнер протестирован на Google Chrome 83.0. 
Для создения контейнера на основе другого браузера необходимо изменить первую строку в Dockerfile **"FROM selenoid/vnc:chrome_83.0"** выбрав из
имеющихся в открытом доступе (https://github.com/aerokube/selenoid/blob/master/docs/browser-image-information.adoc)


КриптоПро csp dist https://www.cryptopro.ru/products/csp/downloads

IFCPlugin dist https://ds-plugin.gosuslugi.ru/plugin/upload/Index.spr

Инструкция от КриптоПро https://support.cryptopro.ru/index.php?/Knowledgebase/Article/View/275

Установка CryptoPro + CadesPlugin + IFCPlugin(Госуслуги, ЕСИА) на Ubuntu https://forum.ubuntu.ru/index.php?topic=300549.0

Извлечь crx для расширения http://crxextractor.com/

Расширение для Chrome https://chrome.google.com/webstore/detail/ifcplugin-extension/pbefkdcndngodfeigfdgiodgnmbgcfha

Сформировать тестовый контейнер можно тут https://www.cryptopro.ru/certsrv/certrqma.asp