{config, ...}: {
  foehammer.services.glance = {
    enable = true;
    pages = [
      {
        name = "Home";
        width = "wide";
        head-widgets = [
          {
            type = "split-column";
            widgets = [
              {
                type = "calendar";
                first-day-of-week = "monday";
              }
              {
                type = "weather";
                units = "imperial";
                hour-format = "24h";
                location = "Minneapolis, United States";
              }
            ];
          }
        ];

        columns = [
          {
            size = "full";
            widgets = [
              {
                type = "hacker-news";
                limit = 15;
              }
              {
                type = "lobsters";
                limit = 15;
              }
            ];
          }
        ];
      }
      {
        name = "Startpage";
        width = "slim";
        hide-desktop-navigation = true;
        center-vertically = true;
        columns = [
          {
            size = "full";
            widgets = [
              {
                type = "search";
                autofocus = true;
                search-engine = "duckduckgo";
              }
              {
                type = "bookmarks";
                groups = [
                  {
                    title = "Communication";
                    links = [
                      {
                        title = "Gmail";
                        url = "https://gmail.com";
                      }
                      {
                        title = "Fastmail";
                        url = "https://fastmail.com";
                      }
                      {
                        title = "Disroot Webmail";
                        url = "https://mail.disroot.org";
                      }
                    ];
                  }
                ];
              }
            ];
          }
        ];
      }
    ];
  };
}
