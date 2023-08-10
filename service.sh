echo "
[Unit]
Description=Phoenix Server
After=network.target

[Service]
Type=simple
User=soc_ex
WorkingDirectory=/home/soc_ex/soc_ex_api
ExecStart=/usr/bin/mix phx.server
Restart=on-failure

[Install]
WantedBy=multi-user.target
" > /etc/systemd/system/soc_ex_api.service
