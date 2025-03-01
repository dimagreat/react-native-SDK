import { IronSourceError } from '../models';
export declare const InterstitialEvents: {
    onInterstitialAdReady: {
        setListener: (listener: () => void) => void;
        removeListener: () => void;
    };
    onInterstitialAdLoadFailed: {
        setListener: (listener: (error: IronSourceError) => void) => void;
        removeListener: () => void;
    };
    onInterstitialAdOpened: {
        setListener: (listener: () => void) => void;
        removeListener: () => void;
    };
    onInterstitialAdClosed: {
        setListener: (listener: () => void) => void;
        removeListener: () => void;
    };
    onInterstitialAdShowSucceeded: {
        setListener: (listener: () => void) => void;
        removeListener: () => void;
    };
    onInterstitialAdShowFailed: {
        setListener: (listener: (error: IronSourceError) => void) => void;
        removeListener: () => void;
    };
    onInterstitialAdClicked: {
        setListener: (listener: () => void) => void;
        removeListener: () => void;
    };
    removeAllListeners: () => void;
};
