$(document).ready(function(){

    var current_user_id = $('body').data('user-id');
    var $comment_text = $('textarea#new_comment');
    var $comment_tags = $('input#tag_list');
    var $comments = $('#comments');

    $('#comment_btn').click(function(e){
        $.ajax({
            type: 'POST',
            url: '/comments',
            dataType: 'html',
            data:
            {
                'comment[content]': $comment_text.val(),
                'comment[user_id]': current_user_id,
                'comment[tag_list]': $comment_tags.val()
            },
            error: error,
            success: function (html) {
                $new_comment = $('<li>' + html + '</li>');
                $comments.append($new_comment);
            }
        });

        return false;
    });

    $comments.on ('click', '.tag_link', function(e){
        var new_tags = prompt("New Tags");
        if (new_tags!=null && new_tags!="")
        {
            $.ajax({
                type: 'POST',
                url: '/tag_comment',
                dataType: 'html',
                data:
                {
                    'comment_id': $(this).parents('div.comment').data('comment-id'),
                    'new_tag_list': new_tags
                },
                error: error,
                success: function (html) {
                    $new_tags = $(html);
                    $comments.append($new_comment);
                }
            });
        }
        return false;
    });


    //Helper Functions

    function error(xhr)
    {
        alert(xhr.responseText);
    }

});

