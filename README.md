vpn-route
=========

Скрипт для настройки доступа в интернет только через OpenVPN.

Установка
---------

работоспособность проверена на Ubuntu 14.04.01
сохраняем скрипт `10vpnroutes.sh` в `/etc/NetworkManager/dispatcher.d/`:

    # wget -O /etc/NetworkManager/dispatcher.d/10vpnroutes.sh https://raw.githubusercontent.com/snake-hole/vpn-route/master/10vpnroutes.sh
    # chmod a+x /etc/NetworkManager/dispatcher.d/10vpnroutes.sh
  
так же, нужно убедиться в отсутствии опции `redirect-gateway` в конфиге OpenVPN, и добавить опцию (если ее нет)

    route 0.0.0.0 0.0.0.0
  
Использование
-------------

Скрипт запускается автоматически при установке подключения к сети в NetworkManager.

* проверяет маршрут по умолчанию, если он на одном из tun интерфейсов (трафик уже идет через VPN), то ничего не делает
* запоминает маршрут по умолчанию
* находит в конфигах OpenVPN в `/etc/openvpn/*.conf` адреса VPN серверов (в опции remote)
* прописывает маршрут к VPN серверам через исходный маршрут по умолчанию
* удаляет маршрут по умолчанию
* перезапускает OpenVPN
