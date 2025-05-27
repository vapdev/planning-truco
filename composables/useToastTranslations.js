import { showToast } from "./toast";

export const useToastTranslations = () => {
  const { $t } = useNuxtApp();

  const showTranslatedToast = (messageKey, options = {}) => {
    showToast({
      message: $t(messageKey),
      position: "top-center",
      offsetY: 4,
      ...options,
    });
  };

  const showErrorToast = (messageKey = "error") => {
    showTranslatedToast(messageKey, { type: "error" });
  };

  const showSuccessToast = (messageKey) => {
    showTranslatedToast(messageKey, { type: "success" });
  };

  return {
    showTranslatedToast,
    showErrorToast,
    showSuccessToast,
  };
};
