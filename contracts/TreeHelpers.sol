// SPDX-License-Identifier: MIT
pragma solidity >=0.8.13 <0.9.0;

import "./APPLE.sol";
import "hardhat/console.sol";

import "abdk-libraries-solidity/ABDKMath64x64.sol";

library TreeHelpers {
    uint256 constant balancer_constant = 5;
    uint256 constant multiplier_constant = 10;

    function apples_to_mint_calculation(
        uint256 birthday_timestamp,
        uint256 growthStrength,
        uint256 appleDecimals,
        uint256 userNutritionScore
    ) public view returns (uint256) {
        uint256 age_ms = block.timestamp - birthday_timestamp;

        uint256 floor = 10**appleDecimals;

        int128 age_years = ABDKMath64x64.divu(age_ms, 31536000);
        int128 age_years_squared = ABDKMath64x64.pow(age_years, 2);

        uint256 fib = fib_level_loop(userNutritionScore, appleDecimals);

        return
            floor +
            multiplier_constant *
            growthStrength *
            (
                ABDKMath64x64.toUInt(
                    ABDKMath64x64.mul(
                        ABDKMath64x64.fromUInt(10**appleDecimals),
                        ABDKMath64x64.div(
                            age_years_squared,
                            ABDKMath64x64.add(
                                age_years_squared,
                                ABDKMath64x64.divu(balancer_constant, fib)
                            )
                        )
                    )
                )
            );
    }

    function uintToString(uint256 _i)
        internal
        pure
        returns (string memory _uintAsString)
    {
        if (_i == 0) {
            return "0";
        }
        uint256 j = _i;
        uint256 len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint256 k = len;
        while (_i != 0) {
            k = k - 1;
            uint8 temp = (48 + uint8(_i - (_i / 10) * 10));
            bytes1 b1 = bytes1(temp);
            bstr[k] = b1;
            _i /= 10;
        }
        return string(bstr);
    }

    function getSvg(
        string memory trunk_color,
        string memory leaf_primary_color,
        string memory leaf_secondary_color
    ) public pure returns (string memory) {
        return
            string(
                abi.encodePacked(
                    "<svg width='100mm' height='100mm' viewBox='0 0 100 113' fill='none' xmlns='http://www.w3.org/2000/svg'>",
                    "<path style='fill:",
                    leaf_primary_color,
                    ";fill-opacity:1;fill-rule:evenodd;stroke:none;stroke-width:.35433072;stroke-linecap:butt;stroke-linejoin:miter;stroke-miterlimit:4;stroke-dasharray:none;stroke-opacity:1' d='M51.696 1007.987c.499.2-5.475 4.025-6.696 3.66-1.34.448-6.071-4.106-6.071-4.106l-6.161 1.16c-5.47-.803-7.937-3.321-11.875-5-.909-2.639-2.068-5.255-.447-8.125-11.886-4.139-7.238-9.53-3.928-14.82-1.82-4.5-1.476-8 4.286-11.787 1.8-3.85.907-10.637 11.16-10.803 4.407-3.327 7.831-9.603 14.197-7.054 11.803-8.597 13.937-2.634 17.321.536 11.462-3.907 12.433 2.69 16.697 5.09 13.562-1.012 12.97 3.439 13.392 7.5-.12 2.599-.802 5.574 2.5 5.892 4.326 4.86 3.588 8.94 1.786 12.857 3.867 10.833-1.13 11.739-2.59 16.607-.941 4.74-3.772 6.731-7.32 7.679l-4.108 1.875c-5.439-.127-7.853-.858-11.071-1.429-6.393 3.962-7.968 1.6-10.804.893z' transform='translate(-8.116 -942.097)'/>",
                    "<path style='color:#000;line-height:normal;text-decoration-style:solid;block-progression:tb;baseline-shift:baseline;display:inline;overflow:visible;visibility:visible;opacity:1;isolation:auto;mix-blend-mode:normal;color-interpolation:sRGB;color-interpolation-filters:linearRGB;solid-color:#000;solid-opacity:1;fill:",
                    leaf_secondary_color,
                    ";fill-opacity:1;fill-rule:evenodd;stroke:none;stroke-width:1.77165353;stroke-linecap:butt;stroke-linejoin:miter;stroke-miterlimit:4;stroke-dasharray:none;stroke-dashoffset:0;stroke-opacity:1;color-rendering:auto;image-rendering:auto;shape-rendering:auto;text-rendering:auto;enable-background:accumulate' d='M56.386 945.769c-4.072-.948-7.829 3.623-10.76 4.638-3.736-1.793-8.23-.259-10.406 3.17-1.702 3.776-4.923 5.032-8.892 4.413-4.393.387-5.82 5.284-6.063 9.007-.735 3.498-6.943 5.125-5.686 10.027.42.903 1.55 2.725 1.394 3.533-1.696 1.52-4.658 4.18-4.281 7.388-.071 3.864 4.506 6.866 8.025 8.147-1.458 4.349.58 10.032 4.918 10.824 3.466 2.432 8.666 3.065 13.165 1.244 3.046-.678 4.281 5.966 8.264 3.848 3.207-.58 4.8-3.679 7.877-4.346 1.667-.102 5.12-.292 6.786-.394 1.4 3.546 5.076 4.893 8.1 3.543 3.608-2.843 6.93-1.155 10.914-.571 3.94.485 5.896-2.11 9.316-2.713 5.025-.041 6.081-6.822 8.737-9.573 3.568-3.905 3.344-10.44 1.448-15.09 1.464-4.194 1.072-10.02-3.034-12.923-4.735-1.006.574-7.672-2.43-10.712-2.525-3.885-9.072-3.57-13.46-3.391-2.922-3.96-7.876-7.625-13.032-5.89-2.294 1.05-3.704 2.045-5.029-.656-1.282-2.158-3.716-3.344-5.87-3.523zm1.195 2.57c3.16.122 5.094 1.125 5.485 4.49 2.943-2.49 6.86-2.216 10.406-.004 2.914.736 4.28 4.668 7.087 4.733 4.753-.375 11.209-.494 12.039 4.702 1.189 1.433-.025 5.003.202 6.709.096.721-1.91 4.3-4.084 5.376-3.685 1.823-9.822-1.056-12.415-4.61.594 5.107 9.419 8.15 13.122 6.448 3.52-1.618 4.517-6.202 4.605-6.194 3.65.65 4.134 3.68 3.608 7.46-.662 3.417-.582 6.854 1.133 10.174.962 4.08-1.62 7.585-4.33 10.43-.454.515-4.876 2.664-6.48 2.294-3.286-.758-7.386-5.274-8.231-6.082-1.467.777 5.13 6.523 8.278 7.768 1.98.783 5.459-1.768 5.425-1.626-.777 3.268-2.55 5.534-5.69 6.19-2.398 3.16-8.39 1.899-11.935.023-2.882-2.395-5.626.886-8.485 1.419-3.312 2.09-5.292-.555-6.987-1.854-2.306.203-4.684.158-6.945.511-3.263 1.589-6.664 4.25-10.459 3.595-1.539-.7-2.184-2.964-3.508-3.687-.177-.097-2.194-.504-4.215-2.483-1.39-1.361-2.29-6.076-3.006-6.024-.719.052.277 5.547 1.537 7.396.723 1.062 3.048 1.522 2.783 1.725-3.482 1.216-7.466.195-9.76-2.602-3.823-.479-7.773-3.465-6.221-7.757.07-.196.714-2.523 1.588-3.843 1.392-2.101 5.293-4.641 6.866-5.318.592-.255 5.441-1.379 5.739-1.917-.245-.984-7.199.862-8.272 1.602-.713.492-3.127 2.403-4.733 3.96-1.054 1.024-2.078 3.51-2.174 3.428-1.193-1.033-3.508-.823-4.021-2.826-2.461-3.484-1.002-8.255 1.65-11.186-1.52-3.235-1.306-7.705 2.197-9.563 4.022-.72 2.173-4.944 3.543-7.618.81-4.621 5.298-4.755 8.733-4.917 2.866-.937 4.524-3.346 6.686-5.243 2.345-2.654 5.384-3.104 8.15-1.577 1.954-3.037 5.52-4.716 9.029-4.406z' transform='translate(-8.116 -942.097)'/>",
                    "<path style='fill:",
                    leaf_secondary_color,
                    ";fill-opacity:1;fill-rule:evenodd;stroke:none;stroke-width:.99921262;stroke-linecap:butt;stroke-linejoin:miter;stroke-miterlimit:4;stroke-dasharray:none;stroke-opacity:1' d='M34.91 965.934c.253-.486 3.153.072 6.192 1.386 2.807 1.214 5.708 3.177 7.364 3.108 3.528-.147 5.664-2.572 7.46-4.286 1.665-1.59 3.1-2.48 3.538-2.53-.268.804.568.86-2.41 3.214-7.3 5.768-6.17 8.754-14.375 2.322-3.66-2.869-6.072-.536-7.768-3.214z' transform='translate(-8.116 -942.097)'/>",
                    "<path style='color:#000;line-height:normal;text-decoration-style:solid;block-progression:tb;baseline-shift:baseline;display:inline;overflow:visible;visibility:visible;opacity:1;isolation:auto;mix-blend-mode:normal;color-interpolation:sRGB;color-interpolation-filters:linearRGB;solid-color:#000;solid-opacity:1;fill:",
                    leaf_secondary_color,
                    ";fill-opacity:1;fill-rule:evenodd;stroke:none;stroke-width:1px;stroke-linecap:butt;stroke-linejoin:miter;stroke-miterlimit:4;stroke-dasharray:none;stroke-dashoffset:0;stroke-opacity:1;color-rendering:auto;image-rendering:auto;shape-rendering:auto;text-rendering:auto;enable-background:accumulate' d='M69.953 971.889c-1.476 2.013-2.408 4.554-4.26 5.54-2.081 1.107-5.062.99-7.355.171l-.281.038-.114.261c-1.91 4.46-5.388 6.653-8.818 6.53-3.43-.122-6.99-1.976-9.107-4.363-1.944-1.574-1.715-1.425-.812.349 2.313 2.606 6.123 4.88 9.882 5.015 3.682.131 7.994-1.696 10.067-6.255 3.007.96 5.612.766 7.913-.584 1.749-1.026 2.35-4.763 3.755-6.68.806-1.207 1.758-2.519.772-2.421z' transform='translate(-8.116 -942.097)'/>",
                    "<path style='fill:",
                    trunk_color,
                    ";fill-opacity:1;fill-rule:evenodd;stroke:none;stroke-width:.38976377;stroke-linecap:butt;stroke-linejoin:miter;stroke-miterlimit:4;stroke-dasharray:none;stroke-opacity:1' d='M52.097 1047.917c-3.696-.593-5.567 1.247-8.333 1.894l-.569-1.641c3.03-2.889 6.109-5.577 9.47-7.134.983-5.958 1.458-12.352 1.263-19.32.144-5.325.46-10.797-1.515-14.331l-13.763-7.197-2.589-2.273-.442-1.894c-.032-1.777.645-1.07 1.263-.568 3.701 5.496 9.392 5.565 10.038 5.05l-.505-3.535 2.084-.884c.852 2.314 1.481 4.778 3.788 6.124 1.783 1.95 2.753 1.196 3.535-.19l.884-1.641v-3.851c.74-.718 1.791-2.65 1.263 1.389.176 2.276.777 3.56 1.452 4.672 1.247.223 1.556 1.214 4.483.063l7.45-2.4c3.261-.663 4.71-2.721 5.808-5.05l1.515.82c-.443 1.284-.568 2.568-1.957 3.852-3.36 2.768-5.583 3.262-8.46 4.42-6.518 1.346-5.812 2.693-7.955 4.04-.542 7.83.407 13.572.631 20.33.44 4.559 1.258 8.55 2.02 12.626.485 1.21 2.746 2.537 5.746 3.914l3.472 2.778c.76 1.504 1.202 2.809-.694 2.652l-5.367-3.346-.884 1.578c-.063.926-.506 1.852-1.578 2.778-1.41.258-1.41-.692-1.705-1.389l-1.389-2.146c-1.773-1.096-2.033-.171-2.904-.063l-1.389 2.146c-.733.47-.982 1.785-2.967.063z' transform='translate(-8.116 -942.097)'/>",
                    "<path style='color:#000;line-height:normal;text-decoration-style:solid;block-progression:tb;baseline-shift:baseline;display:inline;overflow:visible;visibility:visible;opacity:1;isolation:auto;mix-blend-mode:normal;color-interpolation:sRGB;color-interpolation-filters:linearRGB;solid-color:#000;solid-opacity:1;fill:#3a0000;fill-opacity:1;fill-rule:evenodd;stroke:none;stroke-width:1.77165353;stroke-linecap:butt;stroke-linejoin:miter;stroke-miterlimit:4;stroke-dasharray:none;stroke-dashoffset:0;stroke-opacity:1;color-rendering:auto;image-rendering:auto;shape-rendering:auto;text-rendering:auto;enable-background:accumulate' d='M56.245 996.825c.139 3.535.188 4.214-1.147 5.253-.264.361-.844.438-1.01.462-.185.027-.67-.098-1.428-.55a11.78 11.78 0 0 1-3.338-4.728c-.556-1.465-.3-.063-1.07-1.357-.822-1.379-2.282-.92-2.23.074l.098 1.854c.062 1.18-.306-.172-.127.82.162.9 1.15 1.839-1.124 1.768-1.915-.048-3.895-1.429-4.8-1.92-1.864-1.223-2.046-1.59-3.022-3.05-1.264-1.492-1.58-.934-1.96-.2-.002 2.356.533 3.48 2.057 4.618 1.626 1.215 2.873 2.257 5.054 3.085 2.182.83 4.36 2.312 6.318 3.047 1.827.686 3.287 2.007 4.022 3.368 1.082 2.007.614 14.962.453 20.949-.091 3.368-.218 5.143-.552 7.257-.167 1.058-.58 2.216-.82 2.744-1.245 1.31-.57 1.102-2.279 1.973-1.235.604-1.804 1.185-2.3 1.57-.855.592-1.292 1.25-2.229 2.135-.424.68-2.033 1.539-2.095 2.37-.062.672.41 2.295.918 2.393.818-.607 1.996-.74 2.356-1.327 1.073-.627.788.187 1.752-.272.857-.459.308-.161 1.407-.301.609-.077.714-.545.95-.536.84.486 1.122.076 1.404.334.216.385.766.791.725 1.615-.036.715 1.088.978 1.665 1.222.577.243 1.153.146 1.613-.027.46-.174.848-.435 1.168-.717.32-.282.07-.874.237-1.332.44-1.155.922-.391 2.178-.896 1.17.207 1.787-.289 2.1.628.112.453-.214.861.13 1.548.298.518.85 1.655 1.381 1.687.533.031 1.702-.677 2.05-1.296.296-.528.813-.65.901-1.364.11-.889.015-1.31.961-1.366.158-.019 2.4 1.68 4.195 2.565.331.163 1.004.153 2.169-.173.085-.79-.156-1.486-.314-2.518-.991-1.705-2.108-2.288-3.195-2.92-2.427-1.413-3.739-2.026-5.47-4.745-.52-.817-1.12-2.772-1.539-5.671-.424-2.935-1.034-7.31-1.337-10.888-.302-3.578-.297-7.216-.394-10.183-.092-2.804.214-3.927.354-4.984.633-.53 1.638-1.458 2.591-2.007 2.165-1.246 4.977-2.173 8.025-3.176 2.007-.661 3.59-2.204 4.998-3.404 1.409-1.2 1.184-1.868 1.92-3.425.713-.929.376-1.114-.133-1.712-1.096-.471-1.308-.879-1.732-.173-.197 1.607-2.933 3.856-4.077 4.476-1.718.924-3.916 1.237-6.264 2.173-1.158.462-2.382.837-3.298.974-.505.076-1.433.22-1.793.208-.29-.01-1.233-.309-1.574-.55-1.22-2.568-1.538-1.4-1.406-4.532l-.091-1.392c-.772-1.067-1.488-1.69-2.002.522zm.508.893c.28-1.303.56-1.419.839-.533-.073 3.009.33 2.761 1.113 5.933l.065.275.212.188c.711.624 1.01.497 1.777.52.766.025 1.772-.15 2.382-.452 1.218-.603 3.073-.906 3.734-1.17 2.355-.938 3.956-1.132 5.815-2.13.93-.5 2.556-1.703 3.19-2.266.397-.352.745-1.206.977-1.642.257-1.308.941-.691 1.512-.586-.288.801-.577 2.508-2.065 3.743-1.208 1.003-3.392 2.082-5.243 2.964-3.702 1.765-7.62 1.424-10.115 3.675-.94 1.034-1.242 1.028-1.481 1.585-.222 1.33-.23 3.74-.13 6.747.097 3.007.32 6.744.624 10.349.305 3.605.313 6.699.744 9.684.351 2.429.074 3.513.563 4.763.374.957.9 2.546 1.593 3.352 1.157 1.347 5.047 2.703 7.303 3.993.917.525 2.26 2.086 2.162 3.175-.368 1.333-1.758-.162-2.92-.717-.657-.313-1.628-1.235-1.982-1.578-.635-.617-1.176-.894-1.94-1.211-.077-.032-.93-.662-1.475-.904-.587-.26-2.511-1.317-2.676-.963-.118.252 1.698.645 2.34 1.307.356.368.37.694.849 1.102.457.389.376.622.251 1.021-.193.617.068.935-.227 1.932-.174.59-.409 1.271-1.52 1.312-1.161-.147-.545-1.827-.603-2.293-.632-1.71-1.91-1.064-3.278-2.069-1.338.76-1.8.13-2.673 1.33-.47.816-.573 1.489-.905 2.118-.913.962-1.095.725-1.346.19-.196-.705-.931-.68-.962-.907-.031-.228-.469-.472-.374-1.156.02-.27.076-.487.079-.677.001-.11.366-1.001.643-1.778.084-.236.86-.328 1.523-.96.978-.931 1.934-2.445 1.884-2.488-.067-.138-1.057 1.355-2.127 2.257-.725.61-1.213.263-1.584.705-.389.463-.864 1.327-1.229 1.716-.295.316-.782.099-.966.103-.466-.056-1.332.197-2.148.3-1.057.136-.466-.044-2.11.745-1.42.68-1.418.362-1.844.616-.736.617-1.081.465-.978-.28.18-.56.976-1.304 1.229-1.566.384-.298 1.498-1.45 2.528-2.198 1.266-.92 2.924-2.18 4.392-2.382.744-.032 1.21-1.318 1.562-2.095.354-.776.271-1.928.452-3.074.362-2.292.2-7.084.354-10.9.236-5.85-.256-13.88-.745-16.953-.48-3.021-2.892-4.277-4.85-5.025-2.02-.758-4.128-1.987-6.247-2.793a21.463 21.463 0 0 1-5.197-2.854c-1.05-.776-1.27-1.899-1.572-2.81.091-.491.31-.503.697.063.731 1.6 2.063 2.844 3 3.2 1.026.388 1.585.796 3.545 1.583.82.33 2.256.557 3.086.463.238-.043 2.685 2.703 3.562 1.79-.848-.224-2.191-1.115-2.533-2.456-.29-.784-.43-1.91-.517-2.605-.131-1.038.202.482.091-.504-.186-1.664.306-2.582 1.084-.397.333.934.168-.662.544.31.62 2.025.312 1.998 1.552 3.548l1.617 2.019c.977.603 1.81 1.392 2.68 1.266.929-.407.959-.478 1.476-1.202 1.497-2.097 1.167-2.912.937-5.369z' transform='translate(-8.116 -942.097)'/>",
                    "<path style='color:#000;line-height:normal;text-decoration-style:solid;block-progression:tb;baseline-shift:baseline;display:inline;overflow:visible;visibility:visible;opacity:1;isolation:auto;mix-blend-mode:normal;color-interpolation:sRGB;color-interpolation-filters:linearRGB;solid-color:#000;solid-opacity:1;fill:#3b0000;fill-opacity:1;fill-rule:evenodd;stroke:none;stroke-width:1px;stroke-linecap:butt;stroke-linejoin:miter;stroke-miterlimit:4;stroke-dasharray:none;stroke-dashoffset:0;stroke-opacity:1;color-rendering:auto;image-rendering:auto;shape-rendering:auto;text-rendering:auto;enable-background:accumulate' d='M57.121 1007.231c-1.063.975-1.9 2.614-2.09 4.044-.1.745.833 1.705.875 2.869.058 1.64-1.047 3.137-.632 4.725.302 1.157.934 2.438.951 3.574.01.677-.148 2.206-.975 3.515.403.292 1.47-2.117 1.58-3.233.083-1.177-.99-3.01-1.058-4.188-.092-1.63.789-3.124.797-4.147.008-1.06-1.074-2.312-.93-3.361.163-1.178.99-2.299 1.726-3.233.622-.789 2.634-1.494 2.434-1.81 0 0-1.952.58-2.678 1.245z' transform='translate(-8.116 -942.097)'/>",
                    "<path style='color:#000;line-height:normal;text-decoration-style:solid;block-progression:tb;baseline-shift:baseline;display:inline;overflow:visible;visibility:visible;opacity:1;isolation:auto;mix-blend-mode:normal;color-interpolation:sRGB;color-interpolation-filters:linearRGB;solid-color:#000;solid-opacity:1;fill:#3b0000;fill-opacity:1;fill-rule:evenodd;stroke:none;stroke-width:1px;stroke-linecap:butt;stroke-linejoin:miter;stroke-miterlimit:4;stroke-dasharray:none;stroke-dashoffset:0;stroke-opacity:1;color-rendering:auto;image-rendering:auto;shape-rendering:auto;text-rendering:auto;enable-background:accumulate' d='M59.017 1031.907c.676-.97 1.075-2.454 1.005-3.666-.036-.632-.905-1.284-1.114-2.241-.294-1.348.334-2.756-.228-4.007-.41-.912-1.095-1.875-1.28-2.813-.112-.559-.221-1.849.22-3.058-.356-.18-.816 1.976-.733 2.917.115.987 1.226 2.34 1.457 3.304.32 1.336-.136 2.706.013 3.554.154.879 1.184 1.75 1.231 2.64.054 1-.418 2.054-.846 2.94-.362.747-1.814 1.638-1.61 1.868 0 0 1.424-.777 1.885-1.438z' transform='translate(-8.116 -942.097)'/>",
                    "<path style='color:#000;line-height:normal;text-decoration-style:solid;block-progression:tb;baseline-shift:baseline;display:inline;overflow:visible;visibility:visible;opacity:1;isolation:auto;mix-blend-mode:normal;color-interpolation:sRGB;color-interpolation-filters:linearRGB;solid-color:#000;solid-opacity:1;fill:#3b0000;fill-opacity:1;fill-rule:evenodd;stroke:none;stroke-width:1px;stroke-linecap:butt;stroke-linejoin:miter;stroke-miterlimit:4;stroke-dasharray:none;stroke-dashoffset:0;stroke-opacity:1;color-rendering:auto;image-rendering:auto;shape-rendering:auto;text-rendering:auto;enable-background:accumulate' d='M51.515 1043.997c1.181-.509 3.836-1.29 4.218-2.249.199-.5-.592-1.308-.475-2.12.164-1.143 1.457-2.006 1.263-3.168-.141-.848-.592-1.832-.455-2.62.082-.47.445-1.503 1.438-2.28-.358-.264-1.737 1.236-1.997 1.99-.241.801.57 2.236.477 3.06-.129 1.143-1.201 2.039-1.347 2.745-.152.731.747 1.766.462 2.469-.32.79-2.896 1.212-3.749 1.744-.72.448-4.32 2.945-4.165 3.194 0 0 3.524-2.419 4.33-2.765zm5.317-5.197c-.487 1.046-.469 2.343.022 3.213.256.453 1.52.523 2.092 1.136.807.863.523 2.213 1.62 2.876.798.483 1.946.872 2.484 1.481.32.364.886 1.272.76 2.385.49-.037.32-1.864-.097-2.524-.47-.68-2.26-1.156-2.86-1.764-.834-.842-.746-2.082-1.21-2.642-.48-.58-2.01-.736-2.367-1.377-.399-.719-.186-1.73.032-2.595.183-.73 1.63-2.09 1.31-2.164 0 0-1.453 1.262-1.786 1.975z' transform='translate(-8.116 -942.097)'/>",
                    "<path style='color:#000;line-height:normal;text-decoration-style:solid;block-progression:tb;baseline-shift:baseline;display:inline;overflow:visible;visibility:visible;opacity:1;isolation:auto;mix-blend-mode:normal;color-interpolation:sRGB;color-interpolation-filters:linearRGB;solid-color:#000;solid-opacity:1;fill:",
                    leaf_secondary_color,
                    ";fill-opacity:1;fill-rule:evenodd;stroke:none;stroke-width:1px;stroke-linecap:butt;stroke-linejoin:miter;stroke-miterlimit:4;stroke-dasharray:none;stroke-dashoffset:0;stroke-opacity:1;color-rendering:auto;image-rendering:auto;shape-rendering:auto;text-rendering:auto;enable-background:accumulate' d='M41.196 988.821c-.789-1.56-2.258-2.173-.755.657 0 0 .927 6.705 3.814 7.907 2.828 1.177 7.133-3.276 10.191-3.106 3.938.22 6.591 7.9 9.878 6.08 2.873-1.59 9.034-6.127 9.034-6.127 2.27-1.37 2.51-2.315-.631-.963 0 0-5.657 5.257-9.809 4.734-2.6-.327-5.698-4.122-8.245-4.737-2.788-.673-5.814 2.288-8.505 1.297-2.375-.875-4.972-5.742-4.972-5.742z' transform='translate(-8.116 -942.097)'/>",
                    "</svg>"
                )
            );
    }

    function fib_level_loop(uint256 target, uint256 appleDecimals)
        public
        pure
        returns (uint256 fib_level)
    {
        fib_level = 1;
        uint256 count = 10**appleDecimals;
        uint256 previous_count = 10**appleDecimals;

        while (count < target) {
            fib_level++;
            uint256 place_holder_count = count;
            count += previous_count;
            previous_count = place_holder_count;
        }
    }
}
