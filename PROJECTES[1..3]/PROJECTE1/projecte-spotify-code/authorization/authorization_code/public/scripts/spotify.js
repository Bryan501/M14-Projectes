(function() {

  // Obtenció de paràmetres des del hash de la URL
  function getHashParams() {
    var hashParams = {};
    var e, r = /([^&;=]+)=?([^&;]*)/g,
      q = window.location.hash.substring(1);
    while (e = r.exec(q)) {
      hashParams[e[1]] = decodeURIComponent(e[2]);
    }
    return hashParams;
  }

  // Plantilles Handlebars
  var userProfileSource = document.getElementById('user-profile-template').innerHTML,
      userProfileTemplate = Handlebars.compile(userProfileSource),
      userProfilePlaceholder = document.getElementById('user-profile');

  var oauthSource = document.getElementById('oauth-template').innerHTML,
      oauthTemplate = Handlebars.compile(oauthSource),
      oauthPlaceholder = document.getElementById('oauth');

  // Obtenció de paràmetres del hash de la URL
  var params = getHashParams();
    
  var access_token = params.access_token,
      refresh_token = params.refresh_token,
      error = params.error;

  // Maneig d'errors d'autenticació
  if (error) {
    alert('Sha produït un error durant lautenticació');
  } else {
    if (access_token) {
      // Renderització d'informació d'autenticació
      oauthPlaceholder.innerHTML = oauthTemplate({
        access_token: access_token,
        refresh_token: refresh_token
      });

      // Petició AJAX per obtenir dades del perfil
      $.ajax({
        url: 'https://api.spotify.com/v1/me',
        headers: {
          'Authorization': 'Bearer ' + access_token
        },
        success: function(response) {
          userProfilePlaceholder.innerHTML = userProfileTemplate(response);
          $('#login').hide();
          $('#loggedin').show();
        }
      });
    } else {
      // Mostrar pantalla inicial
      $('#login').show();
      $('#loggedin').hide();
    }

    // Esdeveniment per obtenir un nou token
    document.getElementById('obtain-new-token').addEventListener('click', function() {
        $.ajax({
            url: '/refresh_token',
            data: {
                'refresh_token': refresh_token
            }
        }).done(function(data) {
            access_token = data.access_token;
            oauthPlaceholder.innerHTML = oauthTemplate({
                access_token: access_token,
                refresh_token: refresh_token
             });
        });
    }, false);
    
    // Botó per netejar els resultats
    $("#clear_results").click(function(){
      $('#top_tracks').empty();
      $('#artists').empty();
    });

    document.getElementById('button').addEventListener('click', function() {
        $('#artists').empty();
        $('#top_tracks').empty();
    
        console.log($("name").val())
        var artistName = $("#name").val();
        
        if ($("#name").val().indexOf(" ") != -1){
            var replaceSpace = $.trim($("#name").val());
            artistName = replaceSpace.replace(/ /g, "%20");
        }
                                                   
        if (access_token) {
            $.ajax({
            url: 'https://api.spotify.com/v1/search?q=' + artistName + '&type=artist',
            headers: {
                'Authorization': 'Bearer ' + access_token
            },
        
            success: function(response) {
                console.log(access_token);
                console.log(response);
                console.log(response.artists.items[0].name);
        
                var artistsArray = response.artists.items;
                console.log(artistsArray);
          
                var $id;
          
                $.each(artistsArray, function(key, value){
                                    
                    var $name = artistsArray[key].name;
                    console.log($name);
                
                    $id = artistsArray[key].id;
                    console.log($id);
                
                    var $nameDiv = $("<div class='name'/>");
                    var $button = $("<button class='button' id=" + $id + "/>");
                    var $object = $("<div class='object'/>");
                
                     $nameDiv.append($name);
                     $button.append($nameDiv);
                     $object.append($button);
                     $('#artists').append($object);
                });
                
                $('.button').click(function(){
                       
                    console.log(this.id);
      
                  /* curl --request GET \
                    --url https://api.spotify.com/v1/artists/1dfeR4HaWDbWqFHLkxsg1d \
                    --header 'Authorization: Bearer 1POdFZRZbvb...qqillRxMr2z'            */                    

                    $.ajax({
                        url: 'https://api.spotify.com/v1/artists/' + this.id + '/top-tracks?country=ES',
                        type:'GET',
                        headers: {
                            'Authorization': 'Bearer ' + access_token,
                            'Content-type': 'application/json',
                            'Accept': 'application/json'
                        },
        
                        success:function(result){
                            console.log(result);
            
                            $.each(result.tracks,function(key, value){
                                    console.log(value.name + " " + value.external_urls.spotify);
                                    var $top_track = value.name;
                                    var $spotify_url = value.external_urls.spotify;
                                    var $link = $('<a/>').addClass("link").attr("href", $spotify_url).attr("target", "_blank");
                                    var $new_button = $("<button class='new_button'/>");
                                    var $new_object = $("<div class='new_object'/>");
                
                                    $new_button.append($top_track);
                                    $link.append($new_button);
                                    $new_object.append($link);
                                    $('#top_tracks').append($new_object);
                                });
                            },
                            error:function(error){
                                console.log(error)
                            }
                        });
                    });
                }
            }); 
        } else {
            alert('Hi va haver un error durant lautenticació');
        }
    });
  }
})();
