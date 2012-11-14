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

    $comments
    .on ('click', '.tag_link', function(e){
        var new_tags = prompt("New Tags");
        var $comment = $(this).parents('div.comment');

        if (new_tags!=null && new_tags!="")
        {
            $.ajax({
                type: 'POST',
                url: '/comments/'+ $comment.data('comment-id') +'/tag_comment',
                dataType: 'html',
                data:
                {
                    'new_tag_list': new_tags,
                    'title':        $comments.data('title')
                },
                error: error,
                success: function (html) {
                    $comment.replaceWith(html);
                }
            });
        }
        return false;
    })
    .on ('click', '.up_vote', function(e) {
        return vote($(this), current_user_id, true);
    })
    .on ('click', '.down_vote', function(e) {
        return vote($(this), current_user_id, false);
    })
    .on ('click', 'img.thumb', function(e){
        $(this).toggleClass('expanded');
    })
    .on('click', '.spoiler .handle', function(e){
        $('.hidden', $(this).parent()).slideToggle('fast');
    })
    .on('click', '.quote_comment', function(e){
        populate_quote($(this).parents('.comment'));
        scroll_to($comment_text);
        return false;
    });

    //Helper Functions

    function error(xhr)
    {
        alert(xhr.responseText);
    }

    function vote($link, user_id, value)
    {
        var $comment = $link.parents('div.comment');

        $.ajax({
            type: 'POST',
            url: '/comments/'+ $comment.data('comment-id') +'/vote',
            dataType: 'html',
            data:
            {
                'vote[value]': value,
                'vote[user_id]':   user_id,
                'vote[comment_id]':   $comment.data('comment-id')
            },
            error: error,
            success: function (html) {
                $link.parents('.votes').replaceWith(html);
            }
        });

        return false;
    }

    function populate_quote($comment)
    {
        var old_val = $comment_text.val();

        $.ajax({
            type: 'GET',
            url: '/comments/'+ $comment.data('comment-id') +'/content',
            dataType: 'html',
            error: error,
            success: function (content) {
                var quote = "[quote=" + $('.user_name', $comment).text() + "]" + content + "[/quote]";
                $comment_text.val(old_val + "\n\n" + quote);
            }
        });

        return false;
    }

    function scroll_to($obj) {
        $('html, body').animate({
            scrollTop: $obj.offset().top
        }, 1000);
    }

});

