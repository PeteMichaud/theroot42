$(document).ready(function(){

    var current_user_id = $('body').data('user-id');
    var $comment_text = $('textarea#new_comment');
    var $comment_tags = $('input#tag_list');
    var $comments = $('#comments');

    var $reply_form = $('#reply_form');
    var $reply_controls = $('input, textarea', $reply_form);
    var $reply_control_container = $('.controls', $reply_form);

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
                $comment_text.val('');
                $('legend', $reply_form).trigger('click');
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
    })
    .on('click', '.delete_comment', function(e){
        if (confirm('Are you sure you want to delete this comment?'))
        {
            $comment = $(this).parents('.comment');
            $.ajax({
                type: 'DELETE',
                url: '/comments/' + $comment.data('comment-id'),
                dataType: 'html',
                data: { },
                error: error,
                success: function (response) {
                    $comment.remove();
                }
            });
        }
        return false;
    })
    .on('click', '.edit_comment', function(e){
        $comment = $(this).parents('.comment');

        $.ajax({
            type: 'GET',
            url: '/comments/'+ $comment.data('comment-id') +'/content',
            dataType: 'html',
            error: error,
            success: function (content) {
                $('.content', $comment).replaceWith($("<textarea>" + content + "</textarea><a href='#' class='save_changes'>Save Changes</a>"));
            }
        });

        return false;
    })
    .on('click', '.save_changes', function(e){
        var $comment = $(this).parents('.comment');
        var $this_comment_text = $('textarea', $comment);
        $.ajax({
            type: 'PUT',
            url: '/comments/' + $comment.data('comment-id'),
            dataType: 'html',
            data:
            {
                'comment[content]': $this_comment_text.val()
            },
            error: error,
            success: function (html) {
                $comment.replaceWith(html);
            }
        });


        return false;
    });

    //Reply Controls

    $('legend', $reply_form).click(function(e){
        toggle_reply_form();
    });

    var closing_task = -1;
    var mouse_hover = false;
    $('.controls', $reply_form)
        .mouseout(function(e) {
            if (!$reply_controls.is(':focus'))
            {
                closing_task = setTimeout(function(){toggle_reply_form(false)}, 500);
            }
            mouse_hover = false
        })
        .mouseover(function(e) {
            clearTimeout(closing_task);
            mouse_hover = true;
        });

    $reply_controls.blur(function(e) {
        setTimeout(function(){
        if (!mouse_hover && !$reply_controls.is(':focus'))
        {
            toggle_reply_form(false);
        }
        }, 100);
    });

    function toggle_reply_form(open)
    {
        if (open == null)
        {
            $reply_control_container.slideToggle(500, function(){
                if ($reply_control_container.is(':visible'))
                {
                    $comment_text.focus();
                }
            });
        }
        else
        {
            if (open)
            {
                $reply_control_container.slideDown(500, function(){
                    $comment_text.focus();
                });
            }
            else
            {
                $reply_control_container.slideUp(500);
            }
        }
    }

    $(document).keyup(function(e){
        var keyCode = e.keyCode || e.which;

        if (keyCode == 9 && !$reply_control_container.is(':visible'))
        {
            $('legend', $reply_form).trigger('click');
        }
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

