<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>


<section>
    <div class="myPageEdit">
        <h3>내 정보 수정</h3>
        <c:set var="me" value="${loginUser}" />

        <form action="myPageEdit" method="post" id="myPageEditForm">
            <table>
                <tr>
                    <th><label for="username">ID</label></th>
                    <td>
                        <input name="username" id="username" value="${me.username}" readonly>
                    </td>
                </tr>
                <tr>
                    <th><label for="name">NAME</label></th>
                    <td>
                        <input name="name" id="name" value="${me.name}">
                        <div id="checkNameResult" style="font-size: 0.8em; display: none;"></div>
                    </td>
                </tr>
                <tr>
                    <th><label>EMAIL</label></th>
                    <td>
                        <div id="emailField">
                            <input id="emailId" required><span id="middle">@</span><input id="emailAddress">
                            <select class="form-select" aria-label="Default select example" id="emailOption"
                                    onchange="handleEmailOption()" required>
                                <option value="input">직접입력</option>
                                <option value="@naver.com">naver.com</option>
                                <option value="@hanmail.net">hanmail.net</option>
                                <option value="@google.com">google.com</option>
                                <option value="@apple.com">apple.com</option>
                            </select>
                            <input type="hidden" id="totalEmail" name="email" value="">
                            <div id="checkEmailResult" style="font-size: 0.8em; display: none;"></div>
                        </div>
                    </td>
                </tr>

                <tr>
                    <th><label for="phoneNumber">PHONE</label></th>
                    <td>
                        <input name="phoneNumber" id="phoneNumber" value="${me.phoneNumber}" >
                        <div id="checkPhoneResult" style="font-size: 0.8em; display: none;"></div>
                    </td>
                </tr>
                <tr>
                    <th><label for="kakaoAddress">ADDRESS</label></th>
                    <td>
                        <div id=addressField>
                            <input type="text" name="homeAddress" id="kakaoAddress" value="${me.homeAddress}">
                            <input type="button" value="주소 검색" onclick="findAddr();">
                            <div id="checkAddressResult" style="font-size: 0.8em; display: none;"></div>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        <div id=btnField>
                            <button type="submit">수정</button>
                        </div>
                    </td>
                </tr>
            </table>
            <input type="hidden" name="password" value="${me.password}">
        </form>
    </div>
</section>

<script>
    function goBack() {
        window.history.back();
    }

     function findAddr() {
        new daum.Postcode({
            oncomplete: function (data) {
                $("#kakaoAddress").val(data.address);
            }
        }).open();
    }

    function setMyPageEditEmail(email) {
        // 이메일을 @기준으로 분리
        const emailParts = email.split('@');
        // 각각의 필드에 값을 할당
        $("#emailId").val(emailParts[0]);
        $("#emailAddress").val(emailParts[1]);

        const emailOption = "@" + emailParts[1];
        $("#emailOption").val(emailOption);

        if(emailOption === "input") {
            $("#emailAddress").attr("disabled", false);
        } else {
            $("#emailAddress").attr("disabled", true);
        }
        $("#totalEmail").val(email);
    }

    function loadEmail() {
        const currentUserEmail = "${me.email}";

        setMyPageEditEmail(currentUserEmail);
    }

    loadEmail();

     $("#emailId, #emailAddress, #emailOption").on('blur change', function() {
            email();
        });

        function email() {
            const emailId = $("#emailId").val();
            const middle = $("#middle").text();
            const emailAddress = $("#emailAddress").val();
            if(emailId != null && emailAddress != null) {
                $("#totalEmail").val(emailId+middle+emailAddress);
            }
        }
        function handleEmailOption() {
         let emailOption = $("#emailOption").val();
            if (emailOption === "input") {
                $("#emailAddress").val("").attr("disabled", false);
            } else {
                $("#emailAddress").val(emailOption.replace("@", "")).attr("disabled", true);
            }
        }

    let validationResults = {
        name: false,
        phoneNumber: false
    }
    const validateInput = (input, regex, errorMsg, resultElement, fieldName) => {
        const value = input.val().trim();
        if(!value) {
            resultElement.show().css("color", "red").text('필수 입력 값 입니다.');
            validationResults[fieldName] = false;
            return false;
        } else if (!regex.test(value)) {
            resultElement.show().css("color", "red").text(errorMsg);
            validationResults[fieldName] = false;
            return false;
        } else {
            resultElement.show().css("color", "green").text('유효한 값 입니다.');
            validationResults[fieldName] = true;
            return true;
        }
    }

    $(document).ready(() => {
        $("#name").on('input', function () {
            validateInput($(this), /^[a-zA-Z가-힣]+$/,
                '이름을 입력해주세요.', $("#checkNameResult"), "name");
        });
        $("#phoneNumber").on('input', function () {
            validateInput($(this), /^[0-9]{11}$/,
                '숫자만 입력해주세요. 전화번호는 11자리입니다.', $("#checkPhoneResult"), "phoneNumber");
        });
    });

    $("#myPageEditForm").submit(function (event) {
        const allValidOk = Object.values(validationResults).every(result => result);
        if (!allValidOk) {
            event.preventDefault();
            alert("모든 필드를 정확히 입력해주세요.");
            return false;
        }
    });



</script>